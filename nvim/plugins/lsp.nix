{
  pkgs,
  lib,
  nvimInputs,
  icons,
  ...
}:
let
  nixvimLib = nvimInputs.nixvim.lib;

  virtualTypes = pkgs.vimUtils.buildVimPlugin {
    name = "virtual-types-nvim";
    src = nvimInputs.plugins-virtual-types-nvim;
  };

  quintLanguageServer = pkgs.buildNpmPackage {
    pname = "quint-language-server";
    version = "0.19.0";
    src = "${pkgs.quint.src}/vscode/quint-vscode/server";
    npmDepsHash = "sha256-BT5KN9E5aRUIJQR0zGlT00tDmRpS2oFF/yOdQOPIGgQ=";
    npmBuildScript = "compile";
    postPatch = ''
      substituteInPlace src/complete.ts \
        --replace-fail "import { MarkupContent } from 'vscode-languageclient'" "" \
        --replace-fail \
          "import { CompletionItem, CompletionItemKind, MarkupKind, Position } from 'vscode-languageserver/node'" \
          "import { CompletionItem, CompletionItemKind, MarkupContent, MarkupKind, Position } from 'vscode-languageserver/node'"
    '';
  };
in
{
  extraPlugins = [ virtualTypes ];

  extraConfigLua = lib.mkAfter ''
    -- virtual-types.nvim hard-codes TypeAnnot highlight; keep it theme-friendly.
    do
      local function set_type_annot_hl()
        pcall(vim.api.nvim_set_hl, 0, "TypeAnnot", { link = "Comment" })
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_type_annot_hl,
      })

      set_type_annot_hl()
    end
  '';

  plugins.lsp = {
    enable = true;
    servers = {
      bashls.enable = true;
      jsonls.enable = true;
      lua_ls = {
        enable = true;
        settings = {
          Lua = {
            telemetry.enabled = false;
            diagnostics.globals = [ "vim" ];

            workspace.checkThirdParty = false;
            codeLens.enable = true;
            completion.callSnippet = "Replace";
            doc.privateName = [ "^_" ];
            hint = {
              enable = true;
              setType = false;
              paramType = true;
              paramName = "Disable";
              semicolon = "Disable";
              arrayIndex = "Disable";
            };
          };
        };
      };
      nixd.enable = true;
      yamlls.enable = true;
      ts_ls.enable = true;
    };

    capabilities = ''
      capabilities.workspace = capabilities.workspace or {}
      capabilities.workspace.fileOperations = capabilities.workspace.fileOperations or {}
      capabilities.workspace.fileOperations.didRename = true
      capabilities.workspace.fileOperations.willRename = true
    '';

    onAttach = ''
      if vim.bo[bufnr].buftype ~= "" then return end

      local inlay_hints_enabled = true
      local inlay_hints_exclude = { vue = true, cabal = true }
      local folds_enabled = false
      local codelens_enabled = false

      if inlay_hints_enabled
        and vim.lsp.inlay_hint
        and client.supports_method
        and client:supports_method("textDocument/inlayHint")
        and not inlay_hints_exclude[vim.bo[bufnr].filetype]
      then
        pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
      end

      if folds_enabled
        and client.supports_method
        and client:supports_method("textDocument/foldingRange")
      then
        local function apply_folds_to_windows()
          for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
            pcall(vim.api.nvim_set_option_value, "foldmethod", "expr", { win = win })
            pcall(vim.api.nvim_set_option_value, "foldexpr", "v:lua.vim.lsp.foldexpr()", { win = win })
          end
        end

        apply_folds_to_windows()

        vim.api.nvim_create_autocmd("BufWinEnter", {
          buffer = bufnr,
          callback = apply_folds_to_windows,
        })
      end

      if codelens_enabled
        and vim.lsp.codelens
        and client.supports_method
        and client:supports_method("textDocument/codeLens")
      then
        pcall(vim.lsp.codelens.refresh)
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
          buffer = bufnr,
          callback = function()
            pcall(vim.lsp.codelens.refresh)
          end,
        })
      end

      do
        local enabled = vim.g._kremovtort_virtual_types_enabled
        if enabled == nil then enabled = true end

        if enabled
          and client.supports_method
          and client:supports_method("textDocument/codeLens")
        then
          local ok, virtualtypes = pcall(require, "virtualtypes")
          if ok and virtualtypes and type(virtualtypes.on_attach) == "function" then
            local ft = vim.bo[bufnr].filetype
            local allow = {
              ocaml = true,
              ocamlinterface = true,
              reason = true,
            }

            if allow[ft] then
              pcall(vim.api.nvim_buf_call, bufnr, function()
                virtualtypes.on_attach(client, bufnr)
              end)
            end
          end
        end
      end
    '';

    luaConfig.post = ''
      do
        local diag = ${nixvimLib.nixvim.lua.toLuaObject icons.diagnostics}
        local border = "single"

        vim.diagnostic.config({
          underline = true,
          update_in_insert = false,
          severity_sort = true,
          float = {
            border = border,
          },
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
          },
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = diag.Error or "E",
              [vim.diagnostic.severity.WARN] = diag.Warn or "W",
              [vim.diagnostic.severity.HINT] = diag.Hint or "H",
              [vim.diagnostic.severity.INFO] = diag.Info or "I",
            },
          },
        })

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = border,
        })
      end
    '';
  };

  lsp.servers.quint = {
    enable = true;
    package = quintLanguageServer;
    config = {
      cmd = [
        "quint-language-server"
        "--stdio"
      ];
      filetypes = [ "quint" ];
      root_dir.__raw = ''
        function(bufnr, on_dir)
          on_dir(vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
        end
      '';
    };
  };

  filetype.extension.kerml = "kerml";

  # Global keymaps related to LSP
  keymaps = [
    {
      mode = "n";
      key = "<leader>ud";
      action.__raw = ''
        function()
          local enabled = vim.g._kremovtort_diag_enabled
          if enabled == nil then enabled = true end
          enabled = not enabled
          vim.g._kremovtort_diag_enabled = enabled
          vim.diagnostic.enable(enabled)
        end
      '';
      options.desc = "Toggle Diagnostics";
    }
    {
      mode = "n";
      key = "<leader>uh";
      action.__raw = ''
        function()
          local ok = pcall(function()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
          end)
          if not ok then
            vim.notify("Inlay hints not supported in this Neovim/LSP setup", vim.log.levels.WARN)
          end
        end
      '';
      options.desc = "Toggle Inlay Hints";
    }
    {
      mode = "n";
      key = "<leader>uT";
      action.__raw = ''
        function()
          local ok, vt = pcall(require, "virtualtypes")
          if not ok or not vt then
            vim.notify("virtual-types.nvim is not available", vim.log.levels.WARN)
            return
          end

          local enabled = vim.g._kremovtort_virtual_types_enabled
          if enabled == nil then enabled = true end

          if enabled then
            pcall(vt.disable)
          else
            pcall(vt.enable)
          end

          vim.g._kremovtort_virtual_types_enabled = not enabled
        end
      '';
      options.desc = "Toggle Virtual Types";
    }
  ];

  # LSP-only keymaps (applied on LSP attach).
  # See: https://nix-community.github.io/nixvim/lsp/keymaps/index.html
  lsp.keymaps = [
    {
      mode = "n";
      key = "<leader>cl";
      action = "<cmd>LspInfo<cr>";
      options.desc = "Lsp Info";
    }
    {
      mode = "n";
      key = "gd";
      lspBufAction = "definition";
      options.desc = "Goto Definition";
    }
    {
      mode = "n";
      key = "gr";
      lspBufAction = "references";
      options.desc = "References";
    }
    {
      mode = "n";
      key = "gI";
      lspBufAction = "implementation";
      options.desc = "Goto Implementation";
    }
    {
      mode = "n";
      key = "gy";
      lspBufAction = "type_definition";
      options.desc = "Goto Type Definition";
    }
    {
      mode = "n";
      key = "gD";
      lspBufAction = "declaration";
      options.desc = "Goto Declaration";
    }
    {
      mode = "n";
      key = "K";
      lspBufAction = "hover";
      options.desc = "Hover";
    }
    {
      mode = "n";
      key = "gK";
      lspBufAction = "signature_help";
      options.desc = "Signature Help";
    }
    {
      mode = "i";
      key = "<C-k>";
      lspBufAction = "signature_help";
      options.desc = "Signature Help";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>ca";
      lspBufAction = "code_action";
      options.desc = "Code Action";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>cc";
      action.__raw = ''
        function()
          local ok = pcall(function() vim.lsp.codelens.run() end)
          if not ok then
            vim.notify("Codelens not supported in this Neovim/LSP setup", vim.log.levels.WARN)
          end
        end
      '';
      options.desc = "Run Codelens";
    }
    {
      mode = "n";
      key = "<leader>cC";
      action.__raw = ''
        function()
          local ok = pcall(function() vim.lsp.codelens.refresh() end)
          if not ok then
            vim.notify("Codelens not supported in this Neovim/LSP setup", vim.log.levels.WARN)
          end
        end
      '';
      options.desc = "Refresh & Display Codelens";
    }
    {
      mode = "n";
      key = "<leader>cR";
      action.__raw = ''
        function()
          local bufnr = 0
          local old = vim.api.nvim_buf_get_name(bufnr)
          if not old or old == "" then
            vim.notify("No file name for current buffer", vim.log.levels.WARN)
            return
          end

          vim.ui.input({ prompt = "Rename file to: ", default = old }, function(new)
            if not new or new == "" or new == old then return end

            local dir = vim.fn.fnamemodify(new, ":h")
            if dir and dir ~= "" and dir ~= "." then
              pcall(vim.fn.mkdir, dir, "p")
            end

            local oldUri = vim.uri_from_fname(old)
            local newUri = vim.uri_from_fname(new)
            local params = { files = { { oldUri = oldUri, newUri = newUri } } }

            -- Best-effort: ask LSP for workspace edits before renaming.
            local pending_edits = {}
            for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
              if client.supports_method and client:supports_method("workspace/willRenameFiles") then
                local res = client.request_sync("workspace/willRenameFiles", params, 1000, bufnr)
                if res and res.result and res.result.workspaceEdit then
                  table.insert(pending_edits, { client = client, edit = res.result.workspaceEdit })
                end
              end
            end

            local rc = vim.fn.rename(old, new)
            if rc ~= 0 then
              vim.notify("Rename failed (vim.fn.rename exit code: " .. tostring(rc) .. ")", vim.log.levels.ERROR)
              return
            end

            -- Update current buffer to point at the new path.
            vim.api.nvim_buf_set_name(bufnr, new)
            vim.cmd("silent! edit!")

            -- Apply workspace edits (if any).
            for _, item in ipairs(pending_edits) do
              pcall(vim.lsp.util.apply_workspace_edit, item.edit, item.client.offset_encoding)
            end

            -- Notify LSP after rename (if supported).
            for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
              if client.supports_method and client:supports_method("workspace/didRenameFiles") then
                client.notify("workspace/didRenameFiles", params)
              end
            end
          end)
        end
      '';
      options.desc = "Rename File";
    }
    {
      mode = "n";
      key = "<leader>cr";
      lspBufAction = "rename";
      options.desc = "Rename";
    }
    {
      mode = "n";
      key = "<leader>cA";
      action.__raw = ''
        function()
          vim.lsp.buf.code_action({
            context = { only = { "source" } },
            apply = true,
          })
        end
      '';
      options.desc = "Source Action";
    }
    {
      mode = "n";
      key = "]]";
      action.__raw = ''
        function()
          local ok, illuminate = pcall(require, "illuminate")
          if ok and illuminate and illuminate.goto_next_reference then
            illuminate.goto_next_reference(false)
            return
          end
          local word = vim.fn.expand("<cword>")
          if not word or word == "" then return end
          local pat = "\\V\\<" .. vim.fn.escape(word, "\\") .. "\\>"
          vim.fn.search(pat, "W")
        end
      '';
      options.desc = "Next Reference";
    }
    {
      mode = "n";
      key = "[[";
      action.__raw = ''
        function()
          local ok, illuminate = pcall(require, "illuminate")
          if ok and illuminate and illuminate.goto_prev_reference then
            illuminate.goto_prev_reference(false)
            return
          end
          local word = vim.fn.expand("<cword>")
          if not word or word == "" then return end
          local pat = "\\V\\<" .. vim.fn.escape(word, "\\") .. "\\>"
          vim.fn.search(pat, "bW")
        end
      '';
      options.desc = "Prev Reference";
    }
    {
      mode = "n";
      key = "<A-n>";
      action.__raw = ''
        function()
          local ok, illuminate = pcall(require, "illuminate")
          if ok and illuminate and illuminate.goto_next_reference then
            illuminate.goto_next_reference(false)
            return
          end
          local word = vim.fn.expand("<cword>")
          if not word or word == "" then return end
          local pat = "\\V\\<" .. vim.fn.escape(word, "\\") .. "\\>"
          vim.fn.search(pat, "W")
        end
      '';
      options.desc = "Next Reference";
    }
    {
      mode = "n";
      key = "<A-p>";
      action.__raw = ''
        function()
          local ok, illuminate = pcall(require, "illuminate")
          if ok and illuminate and illuminate.goto_prev_reference then
            illuminate.goto_prev_reference(false)
            return
          end
          local word = vim.fn.expand("<cword>")
          if not word or word == "" then return end
          local pat = "\\V\\<" .. vim.fn.escape(word, "\\") .. "\\>"
          vim.fn.search(pat, "bW")
        end
      '';
      options.desc = "Prev Reference";
    }
    {
      mode = "n";
      key = "<leader>ss";
      action.__raw = ''
        function()
          local ok, snacks = pcall(require, "snacks")
          if ok and snacks and snacks.picker and snacks.picker.lsp_symbols then
            snacks.picker.lsp_symbols()
            return
          end
          vim.lsp.buf.document_symbol()
        end
      '';
      options.desc = "LSP Symbols";
    }
    {
      mode = "n";
      key = "<leader>sS";
      action.__raw = ''
        function()
          local ok, snacks = pcall(require, "snacks")
          if ok and snacks and snacks.picker and snacks.picker.lsp_workspace_symbols then
            snacks.picker.lsp_workspace_symbols()
            return
          end
          vim.lsp.buf.workspace_symbol()
        end
      '';
      options.desc = "LSP Workspace Symbols";
    }
    {
      mode = "n";
      key = "gai";
      action.__raw = ''
        function()
          local ok = pcall(function() vim.lsp.buf.incoming_calls() end)
          if not ok then
            vim.notify("Incoming calls not supported in this Neovim/LSP setup", vim.log.levels.WARN)
          end
        end
      '';
      options.desc = "Calls Incoming";
    }
    {
      mode = "n";
      key = "gao";
      action.__raw = ''
        function()
          local ok = pcall(function() vim.lsp.buf.outgoing_calls() end)
          if not ok then
            vim.notify("Outgoing calls not supported in this Neovim/LSP setup", vim.log.levels.WARN)
          end
        end
      '';
      options.desc = "Calls Outgoing";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>cf";
      lspBufAction = "format";
      options.desc = "Format";
    }
    {
      mode = "n";
      key = "<leader>cd";
      action.__raw = "function() vim.diagnostic.open_float(nil, { scope = 'line' }) end";
      options.desc = "Line Diagnostics";
    }
    {
      mode = "n";
      key = "]d";
      action.__raw = "function() vim.diagnostic.goto_next() end";
      options.desc = "Next Diagnostic";
    }
    {
      mode = "n";
      key = "[d";
      action.__raw = "function() vim.diagnostic.goto_prev() end";
      options.desc = "Prev Diagnostic";
    }
    {
      mode = "n";
      key = "]e";
      action.__raw = "function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end";
      options.desc = "Next Error";
    }
    {
      mode = "n";
      key = "[e";
      action.__raw = "function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end";
      options.desc = "Prev Error";
    }
    {
      mode = "n";
      key = "]w";
      action.__raw = "function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end";
      options.desc = "Next Warning";
    }
    {
      mode = "n";
      key = "[w";
      action.__raw = "function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end";
      options.desc = "Prev Warning";
    }
  ];
}

{ icons, ... }:
{
  extraFiles."lua/plugins/lualine/branch.lua".source = ./lualine/branch.lua;
  extraFiles."lua/plugins/lualine/macro_recording.lua".source = ./lualine/macro_recording.lua;

  plugins.lualine = {
    enable = true;

    luaConfig.post = ''
      -- Lualine: nicer terminal buffer names + highlighting
      do
        local function set_lualine_term_hl()
          local function link(from, to)
            pcall(vim.api.nvim_set_hl, 0, from, { link = to, default = true })
          end

          link("LualineTermNumber", "Number")
          link("LualineTermCommand", "String")
          link("LualineTermCwd", "Directory")

          -- Make lualine_c separator slightly darker than normal text.
          -- Derive from existing lualine theme groups so it follows colorscheme.
          local ok, hls = pcall(vim.api.nvim_get_hl, 0, { name = "lualine_c_normal" })
          if ok and hls and hls.fg and hls.bg then
            local fg = hls.fg
            local bg = hls.bg
            local function mix(a, b, t)
              return math.floor(a + (b - a) * t + 0.5)
            end
            local function blend(c1, c2, t)
              return {
                r = mix(bit.rshift(c1, 16) % 256, bit.rshift(c2, 16) % 256, t),
                g = mix(bit.rshift(c1, 8) % 256, bit.rshift(c2, 8) % 256, t),
                b = mix(c1 % 256, c2 % 256, t),
              }
            end
            local blended = blend(fg, bg, 0.7)
            local hex = string.format("#%02x%02x%02x", blended.r, blended.g, blended.b)
            pcall(vim.api.nvim_set_hl, 0, "LualineCSeparator", { fg = hex, bg = hls.bg, default = true })
          else
            pcall(vim.api.nvim_set_hl, 0, "LualineCSeparator", { link = "Comment", default = true })
          end
        end

        do
          local ok, mod = pcall(require, "plugins.lualine.branch")
          if ok and mod and mod.setup then
            mod.setup()
          end
        end

        do
          local ok, mod = pcall(require, "plugins.lualine.macro_recording")
          if ok and mod and mod.setup then
            mod.setup()
          end
        end

        vim.api.nvim_create_autocmd("User", {
          pattern = "DirenvLoaded",
          callback = function()
            pcall(require("lualine").refresh)
          end,
        })

        vim.api.nvim_create_autocmd("DirChanged", {
          callback = function()
            vim.defer_fn(function()
              pcall(require("lualine").refresh)
            end, 100)
          end,
        })

        vim.api.nvim_create_autocmd("ColorScheme", {
          callback = function()
            set_lualine_term_hl()
          end,
        })

        set_lualine_term_hl()
      end
    '';

    settings = {
      options = {
        theme = "auto";
        globalstatus = true;
        # Use slanted Powerline separators instead of arrow ones.
        section_separators = {
          left = "";
          right = "▐";
        };
        component_separators = {
          left = "";
          right = "·";
        };
        disabled_filetypes.statusline = [
          "dashboard"
          "alpha"
          "ministarter"
          "snacks_dashboard"
        ];
      };

      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [
          {
            __unkeyed-1.__raw = ''
              function()
                local ok, mod = pcall(require, "plugins.lualine.branch")
                local branch = ok and mod and mod.get and mod.get(0) or ""
                if branch == "" then
                  return ""
                end
                return " " .. branch
              end
            '';
          }
        ];
        lualine_c = [
          {
            __unkeyed-1.__raw = ''
              function()
                local root = vim.fs.root(0, { ".git" }) or vim.uv.cwd()
                if not root or root == "" then return "" end
                return vim.fn.fnamemodify(root, ":t")
              end
            '';
            separator = "%#LualineCSeparator#%*";
          }
          {
            __unkeyed-1 = "diagnostics";
            symbols = {
              error = icons.diagnostics.Error;
              warn = icons.diagnostics.Warn;
              info = icons.diagnostics.Info;
              hint = icons.diagnostics.Hint;
            };
            separator = "%#LualineCSeparator#%*";
          }
          {
            __unkeyed-1 = "filetype";
            icon_only = true;
            separator = "";
            padding = {
              left = 1;
            };
            draw_empty = false;
          }
          {
            __unkeyed-1.__raw = ''
              function()
                if vim.bo.buftype == "terminal" then
                  local function stl_escape(text)
                    text = tostring(text or "")
                    text = text:gsub("%%", "%%%%")
                    text = text:gsub("[\r\n]", " ")
                    text = text:gsub("[%z\1-\31]", "")
                    return text
                  end

                  local function hl(group, text)
                    return ("%#" .. group .. "#" .. stl_escape(text) .. "%*")
                  end

                  local function tail(path)
                    if not path or path == "" then return "" end
                    return vim.fn.fnamemodify(path, ":t")
                  end

                  local bufname = vim.api.nvim_buf_get_name(0)
                  local cwd = bufname:match("^term://(.-)//%d+:")
                  local cmd = bufname:match("^term://.-//%d+:(.*)$")

                  local cwd_tail = tail(cwd)

                  local title = vim.b.term_title
                  if title == nil or title == "" then
                    title = cmd or ""
                  end

                  if cwd_tail ~= "" and (title == cwd_tail or title:find(cwd_tail, 1, true)) then
                    local shell = vim.env.SHELL or ""
                    title = tail(shell)
                  end

                  if title:sub(1, 5) == "/nix/" then
                    title = tail(title)
                  end

                  if title == "" then
                    title = "term"
                  end

                  local title_hl = hl("LualineTermCommand", title)
                  local cwd_hl = cwd_tail ~= "" and hl("LualineTermCwd", cwd_tail) or hl("LualineTermCwd", tail(vim.fn.getcwd()))

                  return title_hl .. " in " .. cwd_hl
                end

                local name = vim.api.nvim_buf_get_name(0)
                if name == "" then return "[No Name]" end
                local root = vim.fs.root(0, { ".git" }) or vim.uv.cwd() or ""
                local rel = name
                if root ~= "" and name:sub(1, #root + 1) == root .. "/" then
                  rel = name:sub(#root + 2)
                else
                  rel = vim.fn.fnamemodify(name, ":~")
                end

                local suffix = vim.bo.modified and " [+]" or ""
                local columns = vim.o.columns or vim.fn.winwidth(0)
                local max_len = math.max(20, columns - 80)

                if vim.fn.strdisplaywidth(rel .. suffix) > max_len then
                  rel = vim.fn.pathshorten(rel)
                end

                return rel .. suffix
              end
            '';
            padding = {
              left = 0;
              right = 1;
            };
            separator = "%#LualineCSeparator#%*";
          }
          {
            __unkeyed-1 = "diff";
            symbols = {
              added = "+";
              modified = "~";
              removed = "-";
            };
            source.__raw = ''
              function()
                -- Prefer vcsigns stats (works for jj/git/hg). It stores a lualine-compatible table in b:vcsigns_stats.
                local stats = vim.b.vcsigns_stats
                if stats then
                  return stats
                end

                -- Fallback to gitsigns if present.
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end
            '';
          }
        ];

        lualine_x = [
          {
            __unkeyed-1.__raw = ''
              function()
                local ok, mod = pcall(require, "plugins.lualine.macro_recording")
                if not ok or not mod or not mod.component then return "" end
                return mod.component()
              end
            '';
            separator = "%#LualineCSeparator#·%*";
          }
          {
            __unkeyed-1 = "lsp_status";
            icon = ""; # f013
            symbols = {
              spinner = [
                "⠋"
                "⠙"
                "⠹"
                "⠸"
                "⠼"
                "⠴"
                "⠦"
                "⠧"
                "⠇"
                "⠏"
              ];
              done = "✓";
              separator = " ";
            };
            ignore_lsp = { };
            show_name = true;
            separator = "%#LualineCSeparator#·%*";
          }
          {
            __unkeyed-1.__raw = ''
              function()
                local ok, direnv = pcall(require, "direnv")
                if not ok or not direnv.statusline then return "" end
                return direnv.statusline()
              end
            '';
            separator = "%#LualineCSeparator#·%*";
          }
        ];

        lualine_y = [
          {
            __unkeyed-1 = "location";
            padding = {
              left = 1;
              right = 1;
            };
          }
        ];

        lualine_z = [
          {
            __unkeyed-1 = "progress";
            separator = " ";
            padding = {
              left = 1;
              right = 1;
            };
          }
        ];
      };

      extensions = [
        "trouble"
      ];
    };
  };
}

{
  pkgs,
  lib,
  nvimInputs,
  ...
}:
let
  vcsignsVclib = pkgs.vimUtils.buildVimPlugin {
    name = "vcsigns-vclib-nvim";
    src = nvimInputs.plugins-vclib-nvim;
  };

  asyncNvim =
    (pkgs.vimUtils.buildVimPlugin {
      name = "async-nvim";
      src = nvimInputs.plugins-async-nvim;
    }).overrideAttrs
      (_: {
        doCheck = false;
      });

  vcsigns =
    (pkgs.vimUtils.buildVimPlugin {
      name = "vcsigns-nvim";
      src = nvimInputs.plugins-vcsigns-nvim;
      dependencies = [
        vcsignsVclib
        asyncNvim
      ];
    }).overrideAttrs
      (old: {
        doCheck = false;
      });
in
{
  extraPlugins = [
    vcsignsVclib
    asyncNvim
    vcsigns
  ];

  extraConfigLua = lib.mkAfter ''
    local vcrepo = require("vcrepo")
    local common = require("vcrepo.common")
    local util = require("vcrepo.util")
    local run = require("vclib.run")

    local function diffbase(target_rev)
      if target_rev.revset then
        return target_rev.revset
      end
      return string.format("%s~%d", target_rev.anchor, target_rev.offset)
    end

    vcrepo.add_backend({
      name = "Arc",
      head_revision = "HEAD",

      detect = function(dir)
        if vim.fn.executable "arc" == 0 then
          return nil
        end
        local cmd = { "arc", "rev-parse", "--show-toplevel" }
        local out = run.run_with_timeout(cmd, {cwd = dir}):wait()
        if out.code ~= 0 or not out.stdout then
          return nil
        end
        return vim.trim(out.stdout)
      end,

      show = function(self, target)
        target = common.resolve_target(self, target)
        local revspec = diffbase(target.rev)
        local cmd = {
          "arc",
          "show",
          revspec .. ":" .. target.file,
        }
        local out = util.run_async(cmd, { cwd = self.root })
        return common.content_to_lines(out.stdout)
      end,

      get_changed_files = function(self, target_rev)
        target_rev = common.resolve_target_revision(self, target_rev)
        local revspec = diffbase(target_rev)

        local parent_cmd = {
          "arc",
          "rev-parse",
          revspec .. "~1",
        }
        local parent_out = util.run_async(parent_cmd, { cwd = self.root })
        if parent_out.code ~= 0 or not parent_out.stdout then
          return nil
        end

        local cmd = {
          "arc",
          "diff",
          "--name-only",
          vim.trim(parent_out.stdout),
          target_rev.anchor,
        }
        local out = util.run_async(cmd, { cwd = self.root })
        return common.process_diff_result(out, self.root, target_rev)
      end,

      blame = function(self, file, template)
        assert(template == nil, "Arc blame does not support custom templates")

        local cmd = { "arc", "blame", "--json", "--", file }
        local out = util.run_async(cmd, { cwd = self.root })
        if out.code ~= 0 or not out.stdout or out.stdout == "" then
          return nil
        end

        local ok, payload = pcall(vim.json.decode, out.stdout)
        if not ok or type(payload) ~= "table" or type(payload.annotation) ~= "table" then
          return nil
        end

        local annotations = {}
        for _, entry in ipairs(payload.annotation) do
          if type(entry) == "table" and entry.line and entry.commit and entry.text then
            local content = entry.text
            if content:sub(-1) == "\n" then
              content = content:sub(1, -2)
            end

            table.insert(annotations, {
              line_num = entry.line,
              annotation = entry.commit:sub(1, 8),
              content = content,
            })
          end
        end

        table.sort(annotations, function(a, b)
          return a.line_num < b.line_num
        end)

        return annotations
      end,
      needs_refresh = function(self)
        return true
      end,
      -- Rename resolution not implemented for Arc.
      resolve_rename = nil,
    })

    require("vcsigns").setup({
      target_commit = 1,
    })
  '';

  keymaps = [
    {
      mode = "n";
      key = "[h";
      action.__raw = ''function() require("vcsigns.actions").hunk_prev(0, vim.v.count1) end'';
      options.desc = "Prev hunk";
    }
    {
      mode = "n";
      key = "]h";
      action.__raw = ''function() require("vcsigns.actions").hunk_next(0, vim.v.count1) end'';
      options.desc = "Next hunk";
    }
    {
      mode = "n";
      key = "[H";
      action.__raw = ''function() require("vcsigns.actions").hunk_prev(0, 9999) end'';
      options.desc = "First hunk";
    }
    {
      mode = "n";
      key = "]H";
      action.__raw = ''function() require("vcsigns.actions").hunk_next(0, 9999) end'';
      options.desc = "Last hunk";
    }
    {
      mode = "n";
      key = "[r";
      action.__raw = ''function() require("vcsigns.actions").target_older_commit(0, vim.v.count1) end'';
      options.desc = "Target older revision";
    }
    {
      mode = "n";
      key = "]r";
      action.__raw = ''function() require("vcsigns.actions").target_newer_commit(0, vim.v.count1) end'';
      options.desc = "Target newer revision";
    }
    {
      mode = "n";
      key = "<leader>ju";
      action.__raw = ''function() require("vcsigns.actions").hunk_undo(0) end'';
      options.desc = "Undo hunks under cursor";
    }
    {
      mode = [ "v" ];
      key = "<leader>ju";
      action.__raw = ''function() require("vcsigns.actions").hunk_undo(0) end'';
      options.desc = "Undo hunks in range";
    }
    {
      mode = "n";
      key = "<leader>uj";
      action.__raw = ''function() require("vcsigns.actions").toggle_hunk_diff(0) end'';
      options.desc = "Toggle inline hunk diff";
    }
    {
      mode = "n";
      key = "<leader>jf";
      action.__raw = ''function() require("vcsigns.fold").toggle(0) end'';
      options.desc = "Fold outside hunks";
    }
  ];
}

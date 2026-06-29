{
  plugins.tabterm = {
    enable = true;
    settings = {
      ui = {
        border = "round";
        sidebar_width = 30;
        float = {
          width = 0.90;
          height = 0.90;
        };
      };
    };
  };

  keymaps = [
    {
      mode = [
        "n"
        "t"
      ];
      key = "<C-/>";
      action.__raw = ''function() require("tabterm").toggle() end'';
      options.desc = "Toggle tab terminals";
    }
  ];

  autoGroups.tabterm_notify_group.clear = true;

  autoCmd = [
    # Notify when a shell command finishes while tabterm is hidden.
    {
      event = "User";
      pattern = "TabtermShellCommandFinished";
      group = "tabterm_notify_group";
      callback.__raw = ''
        function(ev)
          local data = ev.data or {}
          if data.workspace_visible then
            return
          end

          local label = data.command_label or data.terminal_label or "shell command"
          local level = data.success and vim.log.levels.INFO or vim.log.levels.ERROR
          vim.notify(("%s finished"):format(label), level)
        end
      '';
    }
  ];
}

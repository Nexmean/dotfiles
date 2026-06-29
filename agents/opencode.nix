{
  agents,
  agentsInputs,
  config,
  lib,
  pkgs,
  system,
  ...
}:
let
  configDir = ".config/opencode";
  localSkillDirs = lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./skills);
  localSkills = lib.mapAttrs (name: _: agents + "/skills/${name}") localSkillDirs;
  opencodeVim = import ./opencode-vim { inherit agentsInputs pkgs system; };
in
{
  home.sessionVariables = {
    OPENCODE_ENABLE_EXA = 1;
  };

  home.file."${configDir}/magic-context.jsonc".text = builtins.toJSON {
    "$schema" =
      "https://raw.githubusercontent.com/cortexkit/opencode-magic-context/master/assets/magic-context.schema.json";
    enabled = true;

    historian = {
      model = "openai/gpt-5.5";
    };

    execute_threshold_tokens."zai-coding-plan/glm-5.2" = 160 * 1000;

    dreamer = {
      enabled = true;
      model = "openai/gpt-5.5";
    };

    sidekick = {
      enabled = true;
      model = "opencode-go/minimax-m3";
    };
  };

  home.file."${configDir}/instructions/base.md".source = ./opencode/instructions/base.md;
  home.file."${configDir}/instructions/subagent-json-format.md".source =
    ./opencode/instructions/subagent-json-format.md;
  programs.bun.enable = true; # need for plannotator

  programs.opencode = {
    enable = true;
    package = opencodeVim;
    agents = ./opencode/agents;
    commands = ./commands;
    skills = {
      ast-grep = agentsInputs.astGrepSkill + "/ast-grep/skills/ast-grep";
      skill-creator = agentsInputs.openaiSkills + "/skills/.system/skill-creator";
      qmd = agentsInputs.qmd + "/skills/qmd";
    }
    // localSkills;

    settings = {
      "$schema" = "https://opencode.ai/config.json";

      autoupdate = false;

      plugin = [
        "@plannotator/opencode"
        "@cortexkit/opencode-magic-context"
        "opencode-direnv"
      ];

      instructions = [
        "~/.config/opencode/instructions/*"
      ];

      compaction = {
        prune = false;
        auto = false;
      };

      permission =
        let
          readonly = dir: {
            external_directory.${dir} = "allow";
            read.${dir} = "allow";
            write.${dir} = "deny";
          };
        in
        {
          websearch = "allow";
          "codegraph_*" = "allow";
        }
        // readonly "/nix/store/**"
        // readonly "~/.cargo/registry/**";

      mcp = {
        context7 = {
          type = "local";
          enabled = true;
          command = [
            "${pkgs.nodejs}/bin/npx"
            "-y"
            "@upstash/context7-mcp"
            "--api-key"
            "{file:${config.sops.secrets.context7-api-key.path}}"
          ];
        };

        web_fetch_md = {
          type = "local";
          enabled = true;
          command = [
            "npx"
            "-y"
            "@just-every/mcp-read-website-fast"
          ];
        };

        codegraph = {
          type = "local";
          enabled = true;
          command = [
            "codegraph"
            "serve"
            "--mcp"
          ];
        };

        vision = {
          type = "local";
          enabled = true;
          command = [
            "npx"
            "-y"
            "@z_ai/mcp-server"
          ];
          environment = {
            Z_AI_MODE = "ZAI";
            Z_AI_API_KEY = "{file:${config.sops.secrets.zai-api-key.path}}";
          };
        };

        zread = {
          type = "remote";
          enabled = true;
          url = "https://api.z.ai/api/mcp/zread/mcp";
          headers = {
            Authorization = "Bearer {file:${config.sops.secrets.zai-api-key.path}}";
          };
        };
      };

      agent = {
        plan = {
          mode = "primary";
          model = "openai/gpt-5.5";
          reasoningEffort = "xhigh";
        };

        build = {
          mode = "primary";
          model = "openai/gpt-5.5";
          reasoningEffort = "xhigh";
        };

        ask = {
          mode = "primary";
          model = "openai/gpt-5.5";
          reasoningEffort = "xhigh";
          description = "Answer questions and analyze without editing code";
          permission = {
            edit = "deny";
          };
        };

        general = {
          model = "openai/gpt-5.5-fast";
          reasoningEffort = "high";
        };
      };

      provider = {
        minimax.options.apiKey = "{file:${config.sops.secrets.minimax-coding-plan-key.path}}";

        opencode.options.apiKey = "{file:${config.sops.secrets.opencode-api-key.path}}";

        opencode-go.options.apiKey = "{file:${config.sops.secrets.opencode-api-key.path}}";

        zai-coding-plan.options.apiKey = "{file:${config.sops.secrets.zai-api-key.path}}";
      };

      lsp = false;
    };

    tui = {
      plugin = [
        "@cortexkit/opencode-magic-context"
      ];

      keybinds = {
        leader = "ctrl+x";
        app_exit = "ctrl+d,ctrl+в,<leader>q,<leader>й";
        editor_open = "<leader>e";
        theme_list = "<leader>t";
        sidebar_toggle = "<leader>b";
        status_view = "<leader>s";
        session_export = "<leader>x";
        session_new = "<leader>n";
        session_list = "<leader>l";
        session_timeline = "<leader>g";
        session_rename = "ctrl+r";
        session_delete = "ctrl+d";
        stash_delete = "ctrl+d";
        model_provider_list = "ctrl+a";
        model_favorite_toggle = "ctrl+f";
        session_interrupt = "ctrl+c";
        session_compact = "<leader>c";
        messages_page_up = "pageup,ctrl+alt+b";
        messages_page_down = "pagedown,ctrl+alt+f";
        messages_line_up = "ctrl+alt+y";
        messages_line_down = "ctrl+alt+e";
        messages_half_page_up = "ctrl+alt+u";
        messages_half_page_down = "ctrl+alt+d";
        messages_first = "ctrl+g,home";
        messages_last = "ctrl+alt+g,end";
        messages_copy = "<leader>y";
        messages_undo = "<leader>u";
        messages_redo = "<leader>r";
        messages_toggle_conceal = "<leader>h";
        model_list = "<leader>m";
        command_list = "ctrl+p";
        agent_list = "<leader>a";
        variant_cycle = "ctrl+t";
        input_clear = "ctrl+c";
        input_paste = "ctrl+v";
        input_newline = "shift+return,ctrl+return,alt+return,ctrl+j";
        input_move_left = "left,ctrl+b";
        input_move_right = "right,ctrl+f";
        input_line_home = "ctrl+a";
        input_line_end = "ctrl+e";
        input_select_line_home = "ctrl+shift+a";
        input_select_line_end = "ctrl+shift+e";
        input_visual_line_home = "alt+a";
        input_visual_line_end = "alt+e";
        input_select_visual_line_home = "alt+shift+a";
        input_select_visual_line_end = "alt+shift+e";
        input_delete_line = "ctrl+shift+d";
        input_delete_to_line_end = "ctrl+k";
        input_delete_to_line_start = "ctrl+u";
        input_delete = "ctrl+d,delete,shift+delete";
        input_undo = "ctrl+-,super+z";
        input_redo = "ctrl+.,super+shift+z";
        input_word_forward = "alt+f,alt+right,ctrl+right";
        input_word_backward = "alt+b,alt+left,ctrl+left";
        input_select_word_forward = "alt+shift+f,alt+shift+right";
        input_select_word_backward = "alt+shift+b,alt+shift+left";
        input_delete_word_forward = "alt+d,alt+в,alt+delete,ctrl+delete";
        session_child_first = "ctrl+i";
        session_child_cycle = "ctrl+]";
        session_child_cycle_reverse = "ctrl+[";
        input_delete_word_backward = "ctrl+w,ctrl+backspace,alt+backspace";
        input_force_submit = "alt+return";
        session_parent = "ctrl+o";
        terminal_suspend = "ctrl+z";
        tips_toggle = "<leader>h";
      };
      vim_system_clipboard_register = true;
      vim_langmap = {
        "ё" = "`";
        "Ё" = "~";
        "Ë" = "~";
        "й" = "q";
        "ц" = "w";
        "у" = "e";
        "к" = "r";
        "е" = "t";
        "н" = "y";
        "г" = "u";
        "ш" = "i";
        "щ" = "o";
        "з" = "p";
        "х" = "[";
        "ъ" = "]";
        "ф" = "a";
        "ы" = "s";
        "в" = "d";
        "а" = "f";
        "п" = "g";
        "р" = "h";
        "о" = "j";
        "л" = "k";
        "д" = "l";
        "ж" = ";";
        "э" = "'";
        "я" = "z";
        "ч" = "x";
        "с" = "c";
        "м" = "v";
        "и" = "b";
        "т" = "n";
        "ь" = "m";
        "б" = ",";
        "ю" = ".";
        "Й" = "Q";
        "Ц" = "W";
        "У" = "E";
        "К" = "R";
        "Е" = "T";
        "Н" = "Y";
        "Г" = "U";
        "Ш" = "I";
        "Щ" = "O";
        "З" = "P";
        "Х" = "{";
        "Ъ" = "}";
        "Ф" = "A";
        "Ы" = "S";
        "В" = "D";
        "А" = "F";
        "П" = "G";
        "Р" = "H";
        "О" = "J";
        "Л" = "K";
        "Д" = "L";
        "Ж" = ":";
        "Э" = "\"";
        "Я" = "Z";
        "Ч" = "X";
        "С" = "C";
        "М" = "V";
        "И" = "B";
        "Т" = "N";
        "Ь" = "M";
        "Б" = "<";
        "Ю" = ">";
      };
      theme = "catppuccin-espresso";
    };
  };
}

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
  mattPocockEngineeringDir = agentsInputs.mattPocockSkills + "/skills/engineering";
  mattPocockEngineeringSkillDirs = lib.filterAttrs (_: type: type == "directory") (
    builtins.readDir mattPocockEngineeringDir
  );
  mattPocockEngineeringSkills = lib.mapAttrs (
    name: _: mattPocockEngineeringDir + "/${name}"
  ) mattPocockEngineeringSkillDirs;
  mattPocockProductivityDir = agentsInputs.mattPocockSkills + "/skills/productivity";
  mattPocockProductivitySkillDirs = lib.filterAttrs (_: type: type == "directory") (
    builtins.readDir mattPocockProductivityDir
  );
  mattPocockProductivitySkills = lib.mapAttrs (
    name: _: mattPocockProductivityDir + "/${name}"
  ) mattPocockProductivitySkillDirs;
  opencodeVim = import ./opencode-vim { inherit agentsInputs pkgs system; };
in
{
  home.file.".config/cortexkit/magic-context.jsonc".text = builtins.toJSON {
    "$schema" =
      "https://raw.githubusercontent.com/cortexkit/opencode-magic-context/master/assets/magic-context.schema.json";
    enabled = true;

    historian.model = "openai/gpt-5.6-terra";

    execute_threshold_tokens."zai-coding-plan/glm-5.2" = 160 * 1000;
    execute_threshold_tokens."openai/gpt-5.6-sol" = 200 * 1000;
    execute_threshold_tokens."kimi-for-coding/k3" = 200 * 1000;

    dreamer = {
      enabled = true;
      model = "openai/gpt-5.6-sol";
    };

    sidekick = {
      enabled = true;
      model = "openai/gpt-5.6-terra";
    };
  };

  home.file."${configDir}/instructions/base.md".source = ./opencode/instructions/base.md;
  home.file."${configDir}/plugins/arcadia-search-guard.ts".source =
    ./opencode/plugins/arcadia-search-guard.ts;

  programs.opencode = {
    enable = true;
    package = opencodeVim;
    agents = ./opencode/agents;
    commands = ./commands;
    skills = {
      skill-creator = agentsInputs.openaiSkills + "/skills/.system/skill-creator";
      qmd = agentsInputs.qmd + "/skills/qmd";
      quint-execute-spec = agentsInputs.quintLlmKit + "/quint-llm-kit-plugin/skills/quint-execute-spec";
      quint-lang = agentsInputs.quintLlmKit + "/quint-llm-kit-plugin/skills/quint-lang";
      quint-modeling = agentsInputs.quintLlmKit + "/quint-llm-kit-plugin/skills/quint-modeling";
    }
    // mattPocockEngineeringSkills
    // mattPocockProductivitySkills
    // localSkills;

    settings = {
      "$schema" = "https://opencode.ai/config.json";

      autoupdate = false;

      plugin = [
        "@cortexkit/opencode-magic-context@latest"
        "@dietrichgebert/ponytail"
        "opencode-direnv"
      ];

      instructions = [
        "~/.config/opencode/instructions/*"
      ];

      compaction = {
        prune = false;
        auto = false;
      };

      subagent_depth = 4;

      permission =
        let
          readonly = dir: {
            external_directory.${dir} = "allow";
            read.${dir} = "allow";
            write.${dir} = "deny";
          };
        in
        {
          "codegraph_*" = "allow";
        }
        // readonly "/nix/store/**"
        // readonly "~/.cargo/registry/**";

      mcp = {
        exa = {
          type = "remote";
          enabled = false;
          url = "https://mcp.exa.ai/mcp";
          headers.x-api-key = "{file:${config.sops.secrets.exa-api-key.path}}";
        };

        websearch = {
          type = "remote";
          enabled = true;
          url = "https://api.you.com/mcp";
          headers.Authorization = "Bearer {file:${config.sops.secrets.youcom-api-key.path}}";
        };

        tavily = {
          type = "local";
          enabled = false;
          command = [
            "npx"
            "-y"
            "tavily-mcp@0.2.21"
          ];
          environment.TAVILY_API_KEY = "{file:${config.sops.secrets.tavily-api-key.path}}";
        };

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
          environment.CODEGRAPH_MCP_TOOLS = "explore,search,node,callers,callees,impact,files,status";
        };
      };

      agent = {
        plan = {
          mode = "primary";
          model = "openai/gpt-5.6-sol";
          reasoningEffort = "xhigh";
        };

        build = {
          mode = "primary";
          model = "openai/gpt-5.6-sol";
          reasoningEffort = "xhigh";
        };

        ask = {
          mode = "primary";
          model = "openai/gpt-5.6-sol";
          reasoningEffort = "xhigh";
          description = "Answer questions and analyze without editing code";
          permission = {
            edit = "deny";
          };
        };

        general = {
          model = "openai/gpt-5.6-sol";
          reasoningEffort = "high";
          permission.task."*" = "allow";
          permission.task.general = "deny";
        };

        general-fast = {
          mode = "subagent";
          model = "openai/gpt-5.6-terra";
          reasoningEffort = "high";
          description = "Faster but less capable general-purpose agent. Use for straightforward research and execution tasks where speed matters more than deep reasoning.";
          permission.todowrite = "deny";
          permission.task."*" = "allow";
          permission.task.general = "deny";
          permission.task.general-fast = "deny";
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
        "@cortexkit/opencode-magic-context@latest"
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

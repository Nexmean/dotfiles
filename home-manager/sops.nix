{
  inputs,
  pkgs,
  self,
  config,
  ...
}:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  home.sessionVariables.SOY_TOKEN = ''$(cat "${config.sops.secrets.soy-token.path}")'';
  home.sessionVariables.VMCTL_TOKEN = ''$(cat "${config.sops.secrets.vmctl-token.path}")'';
  home.sessionVariables.MERCURY_AI_TOKEN = ''$(cat "${config.sops.secrets.mercury-ai-token.path}")'';
  home.sessionVariables.TAVILY_API_KEY = ''$(cat "${config.sops.secrets.tavily-api-key.path}")'';
  home.sessionVariables.ZAI_API_KEY = ''$(cat "${config.sops.secrets.zai-api-key.path}")'';

  home.packages = [
    pkgs.age
    pkgs.sops
    pkgs.ssh-to-age
  ];

  launchd.agents.sops-nix = pkgs.lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      EnvironmentVariables = {
        PATH = pkgs.lib.mkForce "/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };

  sops = {
    defaultSopsFile = "${self}/secrets/secrets.yaml";

    age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

    secrets.openrouter-api-key = { };
    secrets.context7-api-key = { };
    secrets.tavily-api-key = { };
    secrets.zai-api-key = { };
    secrets.exa-api-key = { };
    secrets.opencode-api-key = { };
    secrets.soy-token = { };
    secrets.vmctl-token = { };
    secrets.mcp-token = { };
    secrets.minimax-coding-plan-key = { };
    secrets.morphllm-key = { };
    secrets.mercury-ai-token = { };
    secrets.youcom-api-key = { };
  };
}

{
  enable = true;
  global.autoUpdate = false;
  onActivation = {
    autoUpdate = false;
    extraFlags = [ "--verbose" ];
    upgrade = false;
  };
  brews = [
    {
      name = "arc-launcher";
      start_service = true;
      restart_service = "changed";
    }
    "macism"
  ];
  casks = [
    "ungoogled-chromium"
  ];
  taps = [
    "laishulu/homebrew"
    "homebrew/services"
    {
      name = "yandex/arc";
      clone_target = "https://arc-vcs.yandex-team.ru/homebrew-tap";
    }
  ];
}

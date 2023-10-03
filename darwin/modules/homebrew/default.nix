{
  homebrew = {
    enable = true;
    global = {
      autoUpdate = false;
    };
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
    brews = [ "bitwarden-cli" ];
    casks = [
      "tor-browser"
      "telegram"
      # "docker"
      "orbstack"
      "the-unarchiver"
      "signal"
      "motrix"
    ];
    caskArgs = {
      require_sha = false;
      no_quarantine = true;
    };
  };

  environment.extraInit = ''
    eval $(/opt/homebrew/bin/brew shellenv)
  '';
}

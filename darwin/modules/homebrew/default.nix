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
    brews = [ ];
    casks = [
      "brave-browser"
      "telegram"
      "bitwarden"
    ];
    caskArgs = {
      require_sha = true;
      no_quarantine = true;
    };
  };
}

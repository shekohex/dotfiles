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
      "brave-browser"
      "tor-browser"
      "telegram"
      # "docker"
      "orbstack"
      "the-unarchiver"
      "signal"
      "vlc"
      "motrix"
      "cloudflare-warp"
      "microsoft-office"
      "zed"
      "neovide"
      # Trading
      "tradingview"
      "binance"
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

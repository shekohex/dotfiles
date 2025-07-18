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
    masApps = {
      Xcode = 497799835;
    };
    brews = [
      "wakatime-cli"
      "openjdk"
      "ruby"
      "cocoapods"
      "harper"
      "tailscale"
      "ollama"
      "wakeonlan"
      "sst/tap/opencode"
    ];
    casks = [
      "raycast"
      "topnotch"
      "android-file-transfer"
      "brave-browser"
      "tor-browser"
      "protonvpn"
      "proton-pass"
      "proton-mail"
      "proton-drive"
      "telegram"
      "signal"
      # "docker"
      "orbstack"
      "the-unarchiver"
      "signal"
      "vlc"
      "motrix"
      "cloudflare-warp"
      "microsoft-office"
      "neovide"
      "zed"
      # Trading
      "tradingview"
      "binance"
      "jetbrains-toolbox"
      "db-browser-for-sqlite"
      "obsidian"
      "syncthing"
      "localsend"
      "blender"
      "discord"
      "spotify"
      "slack"
      # Tools
      "wealthfolio"
      "cap"
      "insomnia"
    ];
    caskArgs = {
      require_sha = false;
      no_quarantine = true;
    };
  };

  environment.extraInit = ''
    eval $(/opt/homebrew/bin/brew shellenv)
    export GEM_HOME=$HOME/.gem
    export PATH=$GEM_HOME/bin:$PATH
  '';
}

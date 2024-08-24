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
      "bitwarden-cli"
      "openjdk"
      "ruby"
      "cocoapods"
    ];
    casks = [
      "topnotch"
      "android-file-transfer"
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
      "neovide"
      "zed"
      # Trading
      "tradingview"
      "binance"
      "proton-mail"
      "proton-drive"
      "jetbrains-toolbox"
      "db-browser-for-sqlite"
      "obsidian"
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

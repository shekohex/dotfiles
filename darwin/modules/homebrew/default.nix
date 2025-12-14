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
    taps = [
      "hashicorp/tap"
      "coder/coder"
      "steveyegge/beads"
    ];
    brews = [
      "wakatime-cli"
      "openjdk"
      "dotnet"
      "ruby"
      "cocoapods"
      "harper"
      "tailscale"
      "wakeonlan"
      "MisterTea/et/et"
      "ntfy"
      "tea"
      "pgcli"
      "hashicorp/tap/terraform"
      "coder/coder/coder"
      "steveyegge/beads/bd"
    ];
    casks = [
      # "claude"
      "chatgpt"
      "raycast"
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
      "microsoft-office"
      "neovide-app"
      "zed@preview"
      "jetbrains-toolbox"
      "obsidian"
      "syncthing-app"
      "localsend"
      "discord"
      "spotify"
      "slack"
      "whatsapp@beta"
      # Tools
      "insomnia"
      # Terminal
      "ghostty"
      # Game Development
      "dotnet-sdk"
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

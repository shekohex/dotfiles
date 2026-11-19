{
  homebrew = {
    enable = true;
    global = {
      autoUpdate = false;
    };
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };
    masApps = {
      Xcode = 497799835;
    };
    taps = [
      "hashicorp/tap"
      "coder/coder"
      # "steveyegge/beads"
      "oven-sh/bun"
    ];
    brews = [
      "mise"
      "openjdk"
      "ruby"
      "cocoapods"
      "tailscale"
      "wakeonlan"
      "MisterTea/et/et"
      "ntfy"
      "tea"
      "pgcli"
      "hashicorp/tap/terraform"
      "coder/coder/coder"
      # "steveyegge/beads/bd"
      "oven-sh/bun/bun"
    ];
    casks = [
      # "claude"
      "raycast"
      "helium-browser"
      "protonvpn"
      "proton-pass"
      "proton-mail"
      "proton-drive"
      "telegram"
      # "docker"
      "orbstack"
      "the-unarchiver"
      "vlc"
      "motrix"
      "microsoft-office"
      "zed@preview"
      "obsidian"
      "syncthing-app"
      "discord"
      # Disabled: Spotify.
      # "spotify"
      "slack"
      "whatsapp@beta"
      # Tools
      # "insomnia"
      # Terminal
      "ghostty"
      # .NET SDKs
      "dotnet-sdk"
      "dotnet-sdk@9"
    ];
  };

  environment.extraInit = ''
    eval $(/opt/homebrew/bin/brew shellenv)
    export GEM_HOME=$HOME/.gem
    export PATH=$GEM_HOME/bin:$PATH
  '';
}

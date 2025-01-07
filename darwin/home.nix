{ pkgs, user, ... }:

{
  imports = (import ./modules/programs);
  # ++
  # (import ./modules/services);
  home = {
    username = "${user}";
    homeDirectory = "/Users/${user}";
    packages = [
      pkgs.zip
      pkgs.unzip
      pkgs.unrar
      pkgs.dogdns
      pkgs.rsync
      # Tools
      pkgs.raycast
      # pkgs.numbat
      # Editors
      pkgs.android-tools
      pkgs.apktool
      pkgs.jadx
      pkgs.lmstudio
      pkgs.wakatime-cli

      pkgs.google-chrome # Could be useful for testing
    ];
    stateVersion = "24.05";

    sessionPath = [
      # Rust/Cargo binaries
      "$HOME/.cargo/bin"
    ];
  };

  # sourcehut is down, and nmd package cannot be downloaded from git.sr.ht/~rycee/nmd/....
  manual.html.enable = false;
  manual.manpages.enable = false;
  manual.json.enable = false;
  programs = { home-manager.enable = true; };
}

{ pkgs, user, ... }:

{
  imports =
    (import ./modules/programs) ++
    (import ./modules/services);
  home = {
    username = "${user}";
    homeDirectory = "/Users/${user}";
    packages = [
      pkgs.btop
      pkgs.zip
      pkgs.unzip
      pkgs.unrar
      pkgs.dogdns
      pkgs.rsync
      # Tools
      pkgs.raycast
      # Apps
      # pkgs.slack # Uses a lot of Power
      pkgs.spotify
      # Editors
      pkgs.neovide
      pkgs.android-tools
    ];
    stateVersion = "23.11";

    sessionPath = [
      # Rust/Cargo binaries
      "$HOME/.cargo/bin"
    ];
  };

  programs = {
    home-manager.enable = true;
  };
}

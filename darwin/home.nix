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
      pkgs.rsync
      # Tools
      pkgs.raycast
      # Apps
      # pkgs.slack # Uses a lot of Power
      pkgs.spotify
      # Editors
      pkgs.neovide
      # AI Tools
      pkgs.github-copilot-cli
    ];
    stateVersion = "23.05";

    sessionPath = [
      # Rust/Cargo binaries
      "$HOME/.cargo/bin"
    ];
  };

  programs = {
    home-manager.enable = true;
  };
}

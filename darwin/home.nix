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
      pkgs.slack
      pkgs.spotify
      # Editors
      pkgs.neovide
    ];
    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
  };
}

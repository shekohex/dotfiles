{ config, lib, pkgs, user, ... }:

{
  imports = [ ];
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = with pkgs; [
      # Terminal
      btop # Resource Manager
      nitch # Minimal fetch
      tldr # Helper
      # Video/Audio
      vlc # Media Player
      # Apps
      appimage-run # Runs AppImages on NixOS
      brave # Browser
      # File Management
      p7zip # Zip Encryption
      rsync # Syncer - $ rsync -r dir1/ dir2/
      unzip # Zip Files
      unrar # Rar Files
      zip # Zip
      # Password Management
      bitwarden
      # Tailsacle
      # trayscale
      # Tor Client in Rust
      arti
      # Tor Browser
      tor-browser-bundle-bin
      tor
      obfs4
    ];
    stateVersion = "23.05";
  };

  programs = {
    home-manager.enable = true;
  };

  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}

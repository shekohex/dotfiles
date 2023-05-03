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
      bitwarden-cli
    ];
    stateVersion = "22.11";
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

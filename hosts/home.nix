{ pkgs, user, ... }:

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
      dogdns # DNS Client
      # Apps
      appimage-run # Runs AppImages on NixOS
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
    stateVersion = "23.11";
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

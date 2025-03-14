{ pkgs, user, ... }:

{
  imports = [ ];
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = with pkgs; [
      # Terminal
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
      # Mail Client
      protonmail-desktop
      # Tailsacle
      # trayscale
      # Tor Client in Rust
      arti
      # Tor Browser
      tor-browser-bundle-bin
      tor
      obfs4
      obsidian
      jetbrains-toolbox


      # Useful tools
      uv
      nodejs_22
      bun
      pnpm
    ];
    stateVersion = "24.11";
  };

  programs = {
    home-manager.enable = true;
  };
  # sourcehut is down, and nmd package cannot be downloaded from git.sr.ht/~rycee/nmd/....
  manual.html.enable = false;
  manual.manpages.enable = false;
  manual.json.enable = false;
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}

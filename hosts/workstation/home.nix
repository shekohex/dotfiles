{ pkgs, system, zen-browser, zed-editor, ... }:

{
  imports =
    # [ (import ../../modules/wm/kde/home.nix) ] ++
    [ (import ../../modules/wm/gnome/home.nix) ] ++
    [ (import ../../modules/wm/gnome/dconf.nix) ] ++
    (import ../../modules/programs) ++
    (import ../../modules/services);
  home = {
    # Specific packages for desktop
    packages = [
      # Chats and Messengers
      pkgs.telegram-desktop
      pkgs.slack
      pkgs.discord
      pkgs.protonvpn-gui
      pkgs.protonvpn-cli
      pkgs.protonmail-desktop
      # Music
      pkgs.spotify
      # Download Manager
      pkgs.motrix
      # Editors
      pkgs.neovide
      zed-editor.packages."${system}".default
      pkgs.google-chrome # Could be useful for testing
      # Web3
      pkgs.cloudflare-warp
      pkgs.apktool
      pkgs.jadx
      pkgs.ghidra-bin
      pkgs.numbat

      pkgs.nodejs_22
      pkgs.syncthing
      pkgs.obsidian

      # Browsers
      zen-browser.packages."${system}".default
      # 3D Tools
      pkgs.blender-hip
    ];

    sessionPath = [
      # Rust/Cargo binaries
      "$HOME/.cargo/bin"
    ];
  };

  services = {
    # Applets
    blueman-applet.enable = true; # Bluetooth
  };
}

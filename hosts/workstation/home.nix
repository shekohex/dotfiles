{ pkgs, ... }:

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
      pkgs.protonmail-bridge
      pkgs.protonvpn-gui
      # Music
      pkgs.spotify
      # Download Manager
      pkgs.motrix
      # Editors
      pkgs.neovide
      # Web3
      pkgs.framesh
      pkgs.cloudflare-warp
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

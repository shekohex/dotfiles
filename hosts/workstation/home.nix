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
      # Music
      pkgs.spotify
    ];
  };

  services = {
    # Applets
    blueman-applet.enable = true; # Bluetooth
  };
}

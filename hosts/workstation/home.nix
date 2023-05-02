{ config, lib, pkgs, ... }:

{
  imports =
    (import ../../modules/programs) ++
    (import ../../modules/services);
  home = {
    # Specific packages for desktop
    packages = [
      # Chats and Messengers
      pkgs.telegram-desktop
      # Music
      pkgs.spotify
    ];
  };

  services = {
    # Applets
    blueman-applet.enable = true; # Bluetooth
  };
}

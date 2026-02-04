{ pkgs, ... }:

{
  # Enable Niri window manager
  programs.niri = {
    enable = true;
  };

  # Configure GDM to show Niri session alongside GNOME
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # Essential Wayland tools for Niri
  environment.systemPackages = [
    # Status bar
    pkgs.waybar
    # Notifications
    pkgs.mako
    # Application launcher
    pkgs.wofi
    # Clipboard utilities
    pkgs.wl-clipboard
    # Screenshot tools
    pkgs.grim
    pkgs.slurp
    # Brightness control
    pkgs.brightnessctl
    # Volume control
    pkgs.pamixer
    # Additional utilities
    pkgs.libnotify
  ];

  # Enable XDG portal for Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  # Input configuration
  services.libinput.enable = true;
}

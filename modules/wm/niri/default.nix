{ pkgs, ... }:

{
  # Enable Niri window manager
  programs.niri = {
    enable = true;
  };

  # Configure GDM to show Niri session alongside GNOME
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  environment.systemPackages = [
    pkgs.eww
    pkgs.fuzzel
    pkgs.mako
    pkgs.matugen
    pkgs.swww
    pkgs.wl-clipboard
    pkgs.grim
    pkgs.slurp
    pkgs.brightnessctl
    pkgs.pamixer
    pkgs.libnotify
    pkgs.catppuccin-gtk
    pkgs.catppuccin-cursors
    pkgs.papirus-icon-theme
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

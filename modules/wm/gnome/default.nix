{ pkgs, lib, ... }:

let
  extraGnomeExtinction = pkgs.callPackages ./extensions { inherit pkgs lib; };
in
{
  programs = {
    zsh.enable = true;
    dconf.enable = true;
  };

  services = {
    libinput.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "us";
      displayManager.gdm = {
        enable = true;
        wayland = false;
        autoSuspend = false;
      };
      desktopManager.gnome.enable = true; # Window Manager
      updateDbusEnvironment = true;
    };
    accounts-daemon.enable = true;
    udev.packages = [
      pkgs.gnome.gnome-settings-daemon
    ];
    dbus = {
      packages = [ pkgs.gnome2.GConf ];
    };
  };

  hardware.pulseaudio.enable = false;

  xdg = {
    portal = {
      enable = true;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment = {
    # noXlibs = true;
    systemPackages = [
      # Extensions
      pkgs.gnomeExtensions.appindicator
      pkgs.gnomeExtensions.hide-activities-button
      pkgs.gnomeExtensions.blur-my-shell
      pkgs.gnomeExtensions.just-perfection
      extraGnomeExtinction.searchLight
      # Misc
      pkgs.dconf-editor
      pkgs.gnome-tweaks
      # pkgs.wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      pkgs.xclip # clipboard manager
      pkgs.adwaita-qt
    ];

    gnome.excludePackages = (with pkgs; [
      # Gnome ignored packages
      gnome-tour
      epiphany
      geary
      yelp
      cheese # webcam tool
    ]) ++ (with pkgs.gnome; [
      gnome-characters
      tali
      iagno
      hitori
      atomix
      gnome-music
      gnome-contacts
      gnome-initial-setup
    ]);
  };
}

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
    xserver = {
      enable = true;
      layout = "us";
      libinput.enable = true;
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
      pkgs.gnome.dconf-editor
      pkgs.gnome.gnome-tweaks
      # pkgs.wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      pkgs.xclip # clipboard manager
      pkgs.adwaita-qt
    ];

    gnome.excludePackages = (with pkgs; [
      # Gnome ignored packages
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      epiphany
      geary
      gnome-characters
      tali
      iagno
      hitori
      atomix
      yelp
      cheese # webcam tool
      gnome-music
      gnome-contacts
      gnome-initial-setup
    ]);
  };
}

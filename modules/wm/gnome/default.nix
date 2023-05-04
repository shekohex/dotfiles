{ pkgs, ... }:

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
      pkgs.gnomeExtensions.appindicator
      pkgs.gnome.dconf-editor
      pkgs.gnome.gnome-tweaks
      # pkgs.wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    ];
    gnome.excludePackages = (with pkgs; [
      # Gnome ignored packages
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      gedit
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

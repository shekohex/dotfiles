{ pkgs, ... }:

{
  programs = {
    zsh.enable = true;
    dconf.enable = true;
    kdeconnect = {
      # For GSConnect
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };

  services = {
    xserver = {
      enable = true;
      layout = "us";
      libinput.enable = true;
      displayManager.gdm.enable = true; # Display Manager
      desktopManager.gnome.enable = true; # Window Manager
    };
    udev.packages = [
      pkgs.gnome.gnome-settings-daemon
    ];
  };

  hardware.pulseaudio.enable = false;
  environment = {
    # noXlibs = true;
    systemPackages = [
      pkgs.gnome.dconf-editor
      pkgs.gnome.gnome-tweaks
      pkgs.wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
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

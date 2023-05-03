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
      displayManager.gdm.enable = true; # Display Manager
      desktopManager.gnome.enable = true; # Window Manager
    };
    udev.packages = [
      pkgs.gnome.gnome-settings-daemon
    ];
  };

  hardware.pulseaudio.enable = false;

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
      ];
    };
  };

  environment = {
    # noXlibs = true;
    systemPackages = [
      pkgs.gnomeExtensions.appindicator
      pkgs.gnome.dconf-editor
      pkgs.gnome.gnome-tweaks
      pkgs.wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    ];
    loginShellInit = ''
      # Check if gpgconf is installed
      if command -v gpgconf >/dev/null 2>&1; then
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      fi
    '';
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

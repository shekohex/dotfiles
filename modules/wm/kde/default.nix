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
      displayManager = {
        sddm.enable = true; # Display Manager
        defaultSession = "plasmawayland";
      };
      desktopManager.plasma5 = {
        enable = true; # Desktop Manager
        runUsingSystemd = false;
      };
    };
  };

  environment = {
    systemPackages = [
      pkgs.libsForQt5.packagekit-qt
      pkgs.libsForQt5.bismuth
      pkgs.wl-clipboard
      pkgs.kwalletcli
    ];
    plasma5.excludePackages = with pkgs.libsForQt5; [
      elisa
      gwenview
      okular
      oxygen
      khelpcenter
      konsole
      plasma-browser-integration
      print-manager
    ];
  };
}

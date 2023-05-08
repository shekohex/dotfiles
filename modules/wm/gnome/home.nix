{ lib, pkgs, ... }:

let
  extraGnomeThemes = pkgs.callPackages ./themes { inherit pkgs lib; };
in
{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  home.pointerCursor = {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Papirus-Dark";
    };
  };

  home.packages = [
    # To help configure dconf settings
    pkgs.dconf2nix
  ];
}

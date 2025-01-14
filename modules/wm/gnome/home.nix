{ lib, pkgs, ... }:

let extraGnomeThemes = pkgs.callPackages ./themes { inherit pkgs lib; };
in {
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "Adwaita";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };

    gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.papirus-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  home.packages = [
    # To help configure dconf settings
    pkgs.dconf2nix
  ];
}

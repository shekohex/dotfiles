{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.catppuccin-papirus-folders.override
        {
          accent = "teal";
          flavor = "mocha";
        };
    };

    theme = {
      name = "Catppuccin-Mocha-Standard-Teal-Dark";
      package = pkgs.catppuccin-gtk.override
        {
          accents = [ "teal" ];
          size = "standard";
          tweaks = [ "rimless" "black" ]; # You can also specify multiple tweaks here
          variant = "mocha";
        };
    };

    cursorTheme = {
      name = "Catppuccin-Mocha-Teal-Cursors";
      package = pkgs.catppuccin-cursors.mochaTeal;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  home.pointerCursor = {
    name = "Catppuccin-Mocha-Teal-Cursors";
    package = pkgs.catppuccin-cursors.mochaTeal;
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
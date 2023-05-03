{ pkgs, ... }:

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
    font = {
      name = "JetBrainsMono Medium";
    };
  };

  home.packages = [
    pkgs.gnomeExtensions.vitals
    # To help configure dconf settings
    pkgs.dconf2nix
  ];
  home.sessionVariables = { };
}

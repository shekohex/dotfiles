{ pkgs, ... }:

{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha";
      theme_background = false;
    };
  };
  xdg = {
    enable = true;
    configFile."btop/themes" = {
      source = pkgs.fetchFromGitHub
        {
          owner = "catppuccin";
          repo = "btop";
          rev = "c6469190f";
          sha256 = "Mdl0S68mkgeOGIJDpXpFXWpTBIAr6xSXcAxnUjay1iE=";
          sparseCheckout = [ "themes" ];
        } + "/themes";
      recursive = true;
    };
  };
}

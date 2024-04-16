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
          sha256 = "jodJl4f2T9ViNqsY9fk8IV62CrpC5hy7WK3aRpu70Cs=";
          sparseCheckout = [ "themes" ];
        } + "/themes";
      recursive = true;
    };
  };
}

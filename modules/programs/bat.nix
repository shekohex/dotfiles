{ pkgs, ... }:

{
  programs.bat = {
    enable = true;
    extraPackages = [
      pkgs.bat-extras.batwatch
      pkgs.bat-extras.batman
      pkgs.bat-extras.batgrep
      pkgs.bat-extras.batpipe
    ];
    config = { theme = "catppuccinMocha"; };
    themes = {
      catppuccinMocha = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d168";
          sha256 = "6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        };
        file = "Catppuccin-mocha.tmTheme";
      };
    };
  };
}

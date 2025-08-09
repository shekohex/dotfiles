{ pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  ghostty = if isDarwin then pkgs.nur.repos.gigamonster256.ghostty-darwin else pkgs.ghostty;
in
{
  programs.ghostty = {
    enable = true;
    package = ghostty;
    installVimSyntax = true;
    installBatSyntax = true;
    enableZshIntegration = true;
    settings = {
      auto-update = "off";
      theme = "catppuccin-mocha";
      font-family = "Maple Mono NF";
      font-size = if isDarwin then 22 else 16;
      command = "${pkgs.zellij}/bin/zellij -l welcome";
      cursor-style = "bar";
      cursor-style-blink = true;
      mouse-hide-while-typing = true;
      background-opacity = 0.85;
      background-blur = true;
      link-url = true;
      keybind = [
        "shift+enter=text:\"\n\""
      ];
    };
  };
}

{ pkgs, ... }:

{
  programs.vscode = {
    enable = false;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    userSettings = { };
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      sumneko.lua
    ];
  };
}

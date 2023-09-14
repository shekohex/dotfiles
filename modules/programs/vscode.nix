{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    userSettings = { };
    mutableExtensionsDir = true;
    extensions = [ ];
  };
}

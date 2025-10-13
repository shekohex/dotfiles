{ pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isInsiders = false;
  isWindsurf = false;
in
{
  services.vscode-server = {
    enable = !isDarwin;
    nodejsPackage = pkgs.nodejs_24;
    installPath =
      if isInsiders then
        "$HOME/.vscode-server-insiders"
      else if isWindsurf then
        "$HOME/.windsurf-server"
      else
        "$HOME/.vscode-server";
  };
}

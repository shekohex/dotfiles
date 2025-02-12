{ pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isInsiders = true;
in
{
  services.vscode-server = {
    enable = !isDarwin;
    nodejsPackage = pkgs.nodejs_22;
    installPath = if isInsiders then "$HOME/.vscode-server-insiders" else "$HOME/.vscode-server";
  };
}

{ pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  services.vscode-server = {
    enable = !isDarwin;
    nodejsPackage = pkgs.nodejs_22;
  };
}

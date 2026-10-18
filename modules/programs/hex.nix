{ hex, lib, pkgs, ... }:

{
  imports = [ hex.homeManagerModules.hex ];

  programs.hex = {
    package = pkgs.hex-voice;
    gnomeIntegration = lib.mkDefault true;
    autostart = lib.mkDefault true;
  };
}

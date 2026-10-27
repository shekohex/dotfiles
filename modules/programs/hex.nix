{ hex, lib, pkgs, ... }:

{
  imports = [ hex.homeManagerModules.hex ];

  programs.hex = {
    package = pkgs.hex-voice;
    gnomeIntegration = lib.mkDefault true;
    autostart = lib.mkDefault true;
    # First-run seed only. Existing provider settings migrate into editable settings.json.
    initialSettings = {
      release_microphone_while_idle = lib.mkDefault false;
      pause_media_while_recording = lib.mkDefault true;
    };
  };
}

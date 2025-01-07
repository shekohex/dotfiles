{ pkgs, ... }:

{
  programs.spotify-player = {
    enable = true;
    settings = {
      default_device = if pkgs.stdenv.isDarwin then
        "Spotify Player on macbook"
      else
        "Spotify Player on workstation";
    };
  };
}

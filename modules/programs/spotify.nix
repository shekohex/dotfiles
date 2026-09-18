{ pkgs, ... }:

{
  programs.spotify-player = {
    enable = false;
    settings = {
      default_device =
        if pkgs.stdenv.hostPlatform.isDarwin then "Spotify Player on macbook" else "Spotify Player on workstation";
    };
  };
}

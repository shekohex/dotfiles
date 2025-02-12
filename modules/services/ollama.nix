{ pkgs, user, ... }:
let
  pinPackage =
    {
      name,
      commit,
      sha256,
    }:
    (import (builtins.fetchTarball {
      inherit sha256;
      url = "https://github.com/NixOS/nixpkgs/archive/${commit}.tar.gz";
    }) { system = pkgs.system; }).${name};
in
{
  services.ollama = {
    enable = true;
    # pin ollama v0.5.7 until nixpkgs update
    # https://github.com/NixOS/nixpkgs/issues/375359
    package = (
      pinPackage {
        name = "ollama";
        commit = "d0169965cf1ce1cd68e50a63eabff7c8b8959743";
        sha256 = "sha256:1hh0p0p42yqrm69kqlxwzx30m7i7xqw9m8f224i3bm6wsj4dxm05";
      }
    );
    acceleration = "rocm";
    rocmOverrideGfx = "10.3.0";
    host = "0.0.0.0";
    port = 11434;
    openFirewall = true;
    environmentVariables = {
      OLLAMA_ORIGINS = "*";
      OLLAMA_DEBUG = "1";
    };
  };
}

{ pkgs, ... }:
let callPackage = pkgs.lib.callPackageWith (pkgs // { inherit (pkgs) stdenv; });
in {
  WhitesurIconTheme = callPackage ./whitesur/icon-theme.nix { };
  WhitesurGTKTheme = callPackage ./whitesur/gtk-theme.nix { };
}

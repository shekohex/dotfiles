{ pkgs, ... }:
let callPackage = pkgs.lib.callPackageWith (pkgs // { inherit (pkgs) stdenv; });
in
{
  searchLight = callPackage ./search-light { };
}

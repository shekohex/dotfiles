{ pkgs, lib, ... }:

let
  python = pkgs.python3.withPackages (ps: [ ps.pygobject3 ]);

  mediaConvert = pkgs.stdenvNoCC.mkDerivation {
    pname = "media-convert";
    version = "0.1.0";
    dontUnpack = true;
    nativeBuildInputs = [ pkgs.wrapGAppsHook4 pkgs.gobject-introspection ];
    buildInputs = [ pkgs.gtk4 pkgs.libadwaita ];
    installPhase = ''
      install -Dm755 ${pkgs.replaceVars ./media-convert.py { python = python; }} $out/bin/media-convert
    '';
    preFixup = ''
      gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ pkgs.ffmpeg_7-full ]})
    '';
    meta.mainProgram = "media-convert";
  };
in
{
  home.packages = [ mediaConvert ];

  # Needs pkgs.nautilus-python in system packages (see modules/wm/gnome/default.nix).
  xdg.dataFile."nautilus-python/extensions/media-convert.py".source =
    pkgs.replaceVars ./nautilus-extension.py { mediaConvert = lib.getExe mediaConvert; };
}

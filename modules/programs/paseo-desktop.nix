{ pkgs, ... }:

let
  # To update: bump `version` and `hash` (nix hash convert --hash-algo sha256 --to sri <sha256 hex>).
  # Hash: gh release view v<version> -R getpaseo/paseo --json assets --jq '.assets[] | select(.name=="Paseo-x86_64.AppImage") | .digest'
  version = "0.14.0";
  hash = "sha256-IL7xnEScuBVWs4XrB9qH2+8LvhfxV7Z8Ouxl3Ywtidg=";

  pname = "paseo-desktop";
  src = pkgs.fetchurl {
    url = "https://github.com/getpaseo/paseo/releases/download/v${version}/Paseo-x86_64.AppImage";
    inherit hash;
  };
  appimageContents = pkgs.appimageTools.extract { inherit pname version src; };

  paseo-desktop = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/*.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/*.desktop \
        --replace-quiet 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share/icons
    '';

    meta = {
      description = "Paseo desktop app";
      homepage = "https://github.com/getpaseo/paseo";
      platforms = [ "x86_64-linux" ];
      mainProgram = pname;
    };
  };
in
{
  home.packages = [ paseo-desktop ];
}

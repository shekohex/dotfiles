{ pkgs, ... }:

let
  agy = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "agy";
    version = "1.2.13";
    src = pkgs.fetchurl {
      url = "https://github.com/google-antigravity/antigravity-cli/releases/download/${version}/agy_cli_linux_x64.tar.gz";
      hash = "sha256-sPGV03lzvnsIw7cF1/u82Ujay0o8IXbuUsop9xWb3CE=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.glibc ];
    dontUnpack = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/bin"
      tar -xzf "$src" -C "$out/bin" antigravity
      mv "$out/bin/antigravity" "$out/bin/agy"
      runHook postInstall
    '';

    meta = {
      description = "Google Antigravity CLI";
      platforms = [ "x86_64-linux" ];
      mainProgram = "agy";
    };
  };
in
{
  home.packages = [ agy ];
}

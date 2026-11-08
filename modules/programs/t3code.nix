{ pkgs, lib, ... }:

let
  # From repo root: ./scripts/t3code-release.py
  # Prints latest nightly version + desktopHash + cliHash; paste them below.
  # For a specific release: ./scripts/t3code-release.py 0.1.8-nightly.20261104.4165
  # Hashes use GitHub release asset SHA-256 digests, converted to Nix SRI format.
  version = "0.1.8-nightly.20261108.4353";
  desktopHash = "sha256-b1MLQ6lj8jiHJyxbnasUejtFqhleQ78Xb925wbP5PWY=";
  cliHash = "sha256-tLwSkBplHcOv/lHkS7zqv+uh88+WqHQJlcWr3Ej02mM=";
  port = 3157;
  releaseUrl = "https://github.com/pingdotgg/t3code/releases/download/v${version}";

  pname = "t3code-desktop";
  src = pkgs.fetchurl {
    url = "${releaseUrl}/T3-Code-${version}-x86_64.AppImage";
    hash = desktopHash;
  };
  appimageContents = pkgs.appimageTools.extract { inherit pname version src; };
  t3codeDesktop = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/*.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/*.desktop \
        --replace-quiet 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share/icons
    '';

    meta = {
      description = "T3 Code desktop app";
      homepage = "https://github.com/pingdotgg/t3code";
      platforms = [ "x86_64-linux" ];
      mainProgram = pname;
    };
  };

  t3codeCli = pkgs.stdenv.mkDerivation {
    pname = "t3code-cli";
    inherit version;
    src = pkgs.fetchurl {
      url = "${releaseUrl}/t3-${version}-linux-x64.tar.gz";
      hash = cliHash;
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib pkgs.vulkan-loader ];
    # Archive includes optional musl addons; NixOS uses their bundled glibc variants.
    autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];
    # Preserve the executable's embedded Node SEA payload.
    dontStrip = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/libexec/t3code" "$out/bin"
      cp -r . "$out/libexec/t3code"
      ln -s "$out/libexec/t3code/t3" "$out/bin/t3"
      runHook postInstall
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck
      "$out/bin/t3" --version | grep -F '${version}'
      runHook postInstallCheck
    '';

    meta = {
      description = "T3 Code CLI";
      homepage = "https://github.com/pingdotgg/t3code";
      platforms = [ "x86_64-linux" ];
      mainProgram = "t3";
    };
  };
in
lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
  home.packages = [ t3codeDesktop t3codeCli ];

  systemd.user.services.t3code = {
    Unit = {
      Description = "T3 Code server";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "simple";
      WorkingDirectory = "%h";
      Environment = [
        "PATH=%h/.cache/.bun/bin:%h/.local/bin:%h/.cargo/bin:%h/.npm/node_modules/bin:/etc/profiles/per-user/%u/bin:/run/current-system/sw/bin"
      ];
      ExecStart = "${t3codeCli}/bin/t3 serve --host 0.0.0.0 --lan --mode desktop --port ${toString port} --no-browser";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };
}

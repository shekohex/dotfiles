{ pkgs, lib, ... }:

let
  version = "1.0.28-pi.5";
  release = "https://raft.0iq.xyz/computer/${version}";
  photonWasm = pkgs.fetchurl {
    url = "${release}/photon_rs_bg.wasm";
    hash = "sha256-EEaBgVZcVgBMhn86SvlviaDvWmOnLytfsSwfGZKjYVw=";
  };
  raftComputer = pkgs.stdenv.mkDerivation {
    pname = "raft-computer";
    inherit version;
    src = pkgs.fetchurl {
      url = "${release}/raft-computer-linux-x64.gz";
      hash = "sha256-wFd2wpu741ACRGwArSCprFX/jiTcQTDSrukVolb8r2c=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.gzip ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib pkgs.stdenv.cc.libc ];
    dontUnpack = true;
    # The Node SEA payload is stored in the ELF; stripping can break it.
    dontStrip = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/bin"
      gzip -dc "$src" > "$out/bin/raft-computer"
      chmod +x "$out/bin/raft-computer"
      install -m 644 ${photonWasm} "$out/bin/photon_rs_bg.wasm"
      runHook postInstall
    '';
    doInstallCheck = true;
    installCheckPhase = ''
      test "$("$out/bin/raft-computer" --version)" = "${version}"
    '';

    meta = {
      description = "Raft Computer with Pi RPC support";
      platforms = [ "x86_64-linux" ];
      mainProgram = "raft-computer";
    };
  };
in
lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-linux") {
  home.packages = [ raftComputer ];

  systemd.user.services.raft-computer-selfhost = {
    Unit = {
      Description = "Raft Computer (self-hosted)";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "simple";
      WorkingDirectory = "%h";
      ExecStart = "${raftComputer}/bin/raft-computer __service --slock-home %h/.slock --os-supervised systemd-user";
      Restart = "on-failure";
      RestartSec = 2;
      KillMode = "control-group";
    };
    Install.WantedBy = [ "default.target" ];
  };
}


{ pkgs, ... }:

let
  bunInstall = "%h/.cache/.bun";
  paseoBin = "${bunInstall}/bin/paseo";
  bun = "${pkgs.bun}/bin/bun";

  paseoUpgrade = pkgs.writeShellScriptBin "paseo-upgrade" ''
    set -euo pipefail
    export BUN_INSTALL="$HOME/.cache/.bun"
    ${bun} install -g @getpaseo/cli@latest
    systemctl --user restart paseo-daemon.service
  '';
in
{
  home.packages = [ paseoUpgrade ];

  systemd.user.services.paseo-daemon = {
    Unit = {
      Description = "Paseo daemon";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "simple";
      WorkingDirectory = "%h";
      Environment = [
        "BUN_INSTALL=${bunInstall}"
        "PATH=${bunInstall}/bin:%h/.local/bin:%h/.cargo/bin:/etc/profiles/per-user/%u/bin:/run/current-system/sw/bin"
      ];
      # Install CLI from npm on first boot; upgrades via `paseo-upgrade`.
      ExecStartPre = "${pkgs.runtimeShell} -c 'test -x ${paseoBin} || ${bun} install -g @getpaseo/cli@latest'";
      ExecStart = "${paseoBin} daemon run --json";
      Restart = "on-failure";
      KillMode = "process";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };
}

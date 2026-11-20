# `unlock-workstation [host]`: run the workstation's `unlock-agents` using the
# Token2 key plugged into this Mac, so I don't have to be at the workstation.
#
# It forwards this Mac's *restricted* gpg-agent socket (S.gpg-agent.extra: can
# sign/decrypt, cannot export or change keys) into a separate GNUPGHOME on the
# workstation (~/.gnupg-forwarded, public key only), so the workstation's own
# gpg-agent is never replaced. The forward lives only while the command runs;
# every use of the card still needs PIN (pinentry-mac) and a touch here.
{ pkgs, ... }:

let
  gpgFingerprint = "F9F2447AD04C829791F1DE20987ED27840ED60F5";

  unlockWorkstation = pkgs.writeShellApplication {
    name = "unlock-workstation";
    runtimeInputs = [
      pkgs.openssh
      pkgs.gnupg
      pkgs.coreutils
    ];
    text = ''
      host="''${1:-workstation}"
      localSock="$(gpgconf --list-dirs agent-extra-socket)"
      ctl="$(mktemp -u /tmp/unlock-ws.XXXXXX)"
      cleanup() { ssh -o ControlPath="$ctl" -O exit "$host" 2>/dev/null || true; }
      trap cleanup EXIT

      echo "Connecting to $host (touch the key if it blinks)..."
      ssh -o ControlMaster=yes -o ControlPath="$ctl" -o ControlPersist=no -fN "$host"

      # Using the key's FIDO side (the SSH login above) leaves macOS scdaemon
      # with a stale card session ("Not supported"); restart it before GPG.
      gpgconf --kill scdaemon
      gpg --card-status >/dev/null 2>&1 || true

      # Prepare the forwarded GNUPGHOME (public key only) and get its socket path.
      remoteSock="$(gpg --export ${gpgFingerprint} | ssh -o ControlPath="$ctl" "$host" '
        set -e
        export GNUPGHOME="$HOME/.gnupg-forwarded"
        install -d -m 700 "$GNUPGHOME"
        gpg --batch --quiet --no-autostart --import 2>/dev/null
        gpgconf --create-socketdir
        gpgconf --list-dirs agent-socket
      ')"

      ssh -o ControlPath="$ctl" -O forward -R "$remoteSock:$localSock" "$host" >/dev/null
      ssh -o ControlPath="$ctl" -t "$host" 'GNUPGHOME="$HOME/.gnupg-forwarded" unlock-agents'
      ssh -o ControlPath="$ctl" "$host" "rm -f '$remoteSock'"
    '';
  };
in
{
  home.packages = [ unlockWorkstation ];
}

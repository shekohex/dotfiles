# A separate git signing identity for the 24/7 AI agents on this machine.
#
# My own commits are signed by the GPG key on the Token2 cards, which needs a
# touch, so agents can't use it. Agents get their own SSH signing key
# (agent_signing), added to GitHub as a *Signing* key only, so it can be
# revoked in one click without touching my keys.
#
# Pushes and PRs use my normal gh login (gh's git credential helper over HTTPS).
#
# The signing key lives on disk only as ~/.secrets/agents.tar.gpg, encrypted to
# my card-backed GPG key. After each login run `unlock-agents`: PIN + one touch
# loads it into a dedicated ssh-agent (RAM only); then unplug the card. It is
# gone on logout/reboot; `lock-agents` unloads it early.
#
# Agent services (t3code, paseo, raft-computer) run with GIT_CONFIG_GLOBAL
# pointing at agents.gitconfig, layered on my normal git config: author
# "Shady Khalifa (agent)", SSH signing, and git@github.com remotes rewritten
# to HTTPS so pushes never reach for the hardware SSH keys.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  gpgRecipient = "F9F2447AD04C829791F1DE20987ED27840ED60F5";
  home = config.home.homeDirectory;

  # Lets `git log --show-signature` verify agent commits locally.
  allowedSigners = pkgs.writeText "agents-allowed-signers" ''
    14620076+shekohex@users.noreply.github.com namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5BCzSM+EyOgh5UzSarNOnpGt2lVyYUBWT88UTHIZG3 workstation-agents
  '';

  prelude = ''
    rt="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
    dir="$rt/agents"
    sock="$dir/ssh.sock"
    bundle="$HOME/.secrets/agents.tar.gpg"
  '';

  unlockAgents = pkgs.writeShellApplication {
    name = "unlock-agents";
    excludeShellChecks = [ "SC2034" ]; # shared prelude vars
    runtimeInputs = [
      pkgs.gnupg
      pkgs.openssh
      pkgs.gnutar
      pkgs.coreutils
      pkgs.systemd
    ];
    text = ''
      ${prelude}
      if [ ! -f "$bundle" ]; then
        echo "No $bundle yet. Run: agents-secrets init" >&2
        exit 1
      fi
      umask 077
      install -d -m 700 "$dir"
      systemctl --user start agents-ssh-agent.service
      work="$(mktemp -d -p "$rt" agents-unlock.XXXXXX)"
      trap 'rm -rf "$work"' EXIT
      gpgArgs=(--quiet)
      if [ -n "''${GNUPGHOME:-}" ]; then
        # Run by unlock-workstation from the Mac: use only the forwarded agent.
        gpgArgs+=(--no-autostart)
        echo "Using the key on your Mac. Enter the PIN there and touch the key when it blinks..."
      else
        if [ -n "''${SSH_CONNECTION:-}" ]; then
          echo "Tip: over SSH? Run 'unlock-workstation' on the Mac to use the key plugged in there."
        fi
        echo "Plug in your key. Enter the PIN and touch it when it blinks..."
      fi
      gpg "''${gpgArgs[@]}" --decrypt "$bundle" | tar -x -C "$work"
      SSH_AUTH_SOCK="$sock" ssh-add -q "$work/secrets/agent_signing"
      echo "Agents' signing key loaded: $(SSH_AUTH_SOCK="$sock" ssh-add -l)"
      echo "Unlocked until logout/reboot. You can unplug the key now."
    '';
  };

  lockAgents = pkgs.writeShellApplication {
    name = "lock-agents";
    excludeShellChecks = [ "SC2034" ]; # shared prelude vars
    runtimeInputs = [ pkgs.openssh ];
    text = ''
      ${prelude}
      SSH_AUTH_SOCK="$sock" ssh-add -D 2>/dev/null || true
      echo "Agents locked: signing key unloaded."
    '';
  };

  agentsSecrets = pkgs.writeShellApplication {
    name = "agents-secrets";
    excludeShellChecks = [ "SC2034" ]; # shared prelude vars
    runtimeInputs = [
      pkgs.gnupg
      pkgs.openssh
      pkgs.gnutar
      pkgs.coreutils
    ];
    text = ''
      ${prelude}
      umask 077
      case "''${1:-}" in
        init)
          if [ -f "$bundle" ]; then echo "$bundle already exists." >&2; exit 1; fi
          work="$(mktemp -d -p "$rt" agents-secrets.XXXXXX)"
          trap 'rm -rf "$work"' EXIT
          install -d -m 700 "$work/secrets" "$(dirname "$bundle")" "$HOME/.ssh"
          ssh-keygen -q -t ed25519 -N "" -C "workstation-agents" -f "$work/secrets/agent_signing"
          cp "$work/secrets/agent_signing.pub" "$HOME/.ssh/agent_signing.pub"
          tar -C "$work" -c secrets \
            | gpg --quiet --batch --yes --trust-model always \
                --encrypt --recipient ${gpgRecipient} --output "$bundle"
          echo "Created $bundle. Add this to GitHub as a *Signing* key named workstation-agents:"
          cat "$HOME/.ssh/agent_signing.pub"
          ;;
        *)
          echo "usage: agents-secrets init" >&2
          exit 2
          ;;
      esac
    '';
  };

  agentEnvironment = [
    "GIT_CONFIG_GLOBAL=%h/.config/git/agents.gitconfig"
    "SSH_AUTH_SOCK=%t/agents/ssh.sock"
  ];
in
lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
  home.packages = [
    unlockAgents
    lockAgents
    agentsSecrets
  ];

  xdg.configFile."git/agents.gitconfig".text = ''
    # Git identity for AI agents. Layered over my normal config.
    [include]
      path = ${home}/.config/git/config
    [user]
      name = Shady Khalifa (agent)
      signingKey = ${home}/.ssh/agent_signing.pub
    [gpg]
      format = ssh
    [gpg "ssh"]
      allowedSignersFile = ${allowedSigners}
    [commit]
      gpgSign = true
    [tag]
      gpgSign = true
    [url "https://github.com/"]
      insteadOf = git@github.com:
      insteadOf = ssh://git@github.com/
  '';

  systemd.user.services = {
    agents-ssh-agent = {
      Unit.Description = "ssh-agent holding the AI agents' signing key";
      Service = {
        ExecStartPre = "${pkgs.coreutils}/bin/install -d -m 700 %t/agents";
        ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a %t/agents/ssh.sock";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "default.target" ];
    };
    t3code.Service.Environment = agentEnvironment;
    paseo-daemon.Service.Environment = agentEnvironment;
    raft-computer-selfhost.Service.Environment = agentEnvironment;
  };
}

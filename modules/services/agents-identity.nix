# A separate, revocable GitHub identity for the 24/7 AI agents on this machine.
#
# Agents never touch the hardware keys. They get:
#   - an SSH *signing* key (agent_signing), added to GitHub as a Signing key only
#   - fine-grained GitHub tokens, one per owner (shekohex, plus any orgs)
#
# Both live on disk only as ~/.secrets/agents.tar.gpg, encrypted to my GPG key
# (whose decryption subkey is on the Token2 cards). After each login run
# `unlock-agents`: PIN + one touch decrypts them into RAM ($XDG_RUNTIME_DIR),
# loads the signing key into a dedicated ssh-agent, then the hardware key can
# be unplugged. Everything is gone on logout/reboot. `lock-agents` wipes early.
#
# Agent services (t3code, paseo, raft-computer) run with AGENTS_IDENTITY=1 and
# GIT_CONFIG_GLOBAL pointing at agents.gitconfig, which layers on top of my
# normal git config: author "Shady Khalifa (agent)", SSH signing, and
# git@github.com remotes rewritten to HTTPS using the per-owner token.
#
# Manage secrets with:
#   agents-secrets init              # once: create signing key + empty bundle
#   agents-secrets set-token <owner> # add/replace a token (touch to decrypt)
#   agents-secrets list
{
  config,
  lib,
  pkgs,
  ...
}:

let
  gpgRecipient = "F9F2447AD04C829791F1DE20987ED27840ED60F5";
  personalOwner = "shekohex";
  home = config.home.homeDirectory;

  # Shared shell prelude for the scripts below.
  prelude = ''
    rt="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
    dir="$rt/agents"
    secrets="$dir/secrets"
    sock="$dir/ssh.sock"
    bundle="$HOME/.secrets/agents.tar.gpg"
  '';

  # git credential helper: picks the token for the repo owner in the URL path,
  # falling back to the personal token.
  credentialHelper = pkgs.writeShellScript "git-credential-agents" ''
    ${prelude}
    [ "''${1:-}" = get ] || exit 0
    path=""
    while IFS='=' read -r key value; do
      [ -z "$key" ] && break
      [ "$key" = path ] && path="$value"
    done
    owner="''${path%%/*}"
    token="$secrets/tokens/$owner"
    [ -n "$owner" ] && [ -f "$token" ] || token="$secrets/tokens/${personalOwner}"
    [ -f "$token" ] || exit 0
    echo "username=x-access-token"
    echo "password=$(cat "$token")"
  '';

  # gh wrapper: for agent processes (AGENTS_IDENTITY=1) use the token of the
  # repo owner instead of my own login. Everyone else gets plain gh.
  ghWrapper = pkgs.writeShellScript "gh" ''
    if [ "''${AGENTS_IDENTITY:-}" = 1 ] && [ -z "''${GH_TOKEN:-}" ]; then
      ${prelude}
      owner=""
      prev=""
      for arg in "$@"; do
        case "$prev" in -R|--repo) owner="''${arg%%/*}" ;; esac
        case "$arg" in --repo=*) r="''${arg#--repo=}"; owner="''${r%%/*}" ;; esac
        prev="$arg"
      done
      if [ -z "$owner" ]; then
        url="$(git remote get-url origin 2>/dev/null || true)"
        url="''${url#*github.com[:/]}"
        owner="''${url%%/*}"
      fi
      token="$secrets/tokens/$owner"
      [ -n "$owner" ] && [ -f "$token" ] || token="$secrets/tokens/${personalOwner}"
      if [ -f "$token" ]; then
        GH_TOKEN="$(cat "$token")"
        export GH_TOKEN
      fi
    fi
    exec ${pkgs.gh}/bin/gh "$@"
  '';
  ghWrapped = pkgs.symlinkJoin {
    name = "gh-agents-${pkgs.gh.version}";
    paths = [ pkgs.gh ];
    postBuild = ''
      rm "$out/bin/gh"
      cp ${ghWrapper} "$out/bin/gh"
    '';
    inherit (pkgs.gh) meta version;
  };

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
      rm -rf "$secrets"
      echo "Plug in your key. Enter the PIN and touch it when it blinks..."
      gpg --quiet --decrypt "$bundle" | tar -x -C "$dir"
      SSH_AUTH_SOCK="$sock" ssh-add -q "$secrets/agent_signing"
      rm -f "$secrets/agent_signing"
      echo "Signing key loaded: $(SSH_AUTH_SOCK="$sock" ssh-add -l)"
      echo "Tokens for: $(find "$secrets/tokens" -type f -printf "%f " 2>/dev/null)"
      echo "Unlocked until logout/reboot. You can unplug the key now."
    '';
  };

  lockAgents = pkgs.writeShellApplication {
    name = "lock-agents";
    excludeShellChecks = [ "SC2034" ]; # shared prelude vars
    runtimeInputs = [
      pkgs.openssh
      pkgs.coreutils
    ];
    text = ''
      ${prelude}
      SSH_AUTH_SOCK="$sock" ssh-add -D 2>/dev/null || true
      rm -rf "$secrets"
      echo "Agents locked: signing key unloaded, tokens wiped from RAM."
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
      encrypt() { # $1 = dir containing secrets/
        install -d -m 700 "$(dirname "$bundle")"
        tar -C "$1" -c secrets \
          | gpg --quiet --batch --yes --trust-model always \
              --encrypt --recipient ${gpgRecipient} --output "$bundle.new"
        mv "$bundle.new" "$bundle"
      }
      work="$(mktemp -d -p "$rt" agents-secrets.XXXXXX)"
      trap 'rm -rf "$work"' EXIT

      case "''${1:-}" in
        init)
          if [ -f "$bundle" ]; then echo "$bundle already exists." >&2; exit 1; fi
          install -d -m 700 "$work/secrets/tokens"
          ssh-keygen -q -t ed25519 -N "" -C "workstation-agents" -f "$work/secrets/agent_signing"
          install -d -m 700 "$HOME/.ssh"
          cp "$work/secrets/agent_signing.pub" "$HOME/.ssh/agent_signing.pub"
          encrypt "$work"
          echo "Created $bundle. Add this to GitHub as a *Signing* key named workstation-agents:"
          cat "$HOME/.ssh/agent_signing.pub"
          ;;
        set-token)
          owner="''${2:?usage: agents-secrets set-token <owner>}"
          echo "Plug in your key. Enter the PIN and touch it when it blinks..."
          gpg --quiet --decrypt "$bundle" | tar -x -C "$work"
          install -d -m 700 "$work/secrets/tokens"
          printf 'Paste the fine-grained token for %s (hidden), then Enter: ' "$owner"
          IFS= read -rs token </dev/tty
          echo
          [ -n "$token" ] || { echo "Empty token, nothing changed." >&2; exit 1; }
          printf '%s' "$token" > "$work/secrets/tokens/$owner"
          encrypt "$work"
          if [ -d "$secrets/tokens" ]; then cp "$work/secrets/tokens/$owner" "$secrets/tokens/$owner"; fi
          echo "Token for $owner saved."
          ;;
        list)
          if [ -d "$secrets/tokens" ]; then find "$secrets/tokens" -type f -printf "%f\n"; else echo "Locked. Run unlock-agents first." >&2; exit 1; fi
          ;;
        *)
          echo "usage: agents-secrets init | set-token <owner> | list" >&2
          exit 2
          ;;
      esac
    '';
  };

  # Environment shared by every agent service.
  agentEnvironment = [
    "AGENTS_IDENTITY=1"
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

  programs.gh.package = ghWrapped;

  xdg.configFile."git/agents.gitconfig".text = ''
    # Git identity for AI agents. Layered over my normal config.
    [include]
      path = ${home}/.config/git/config
    [user]
      name = Shady Khalifa (agent)
      signingKey = ${home}/.ssh/agent_signing.pub
    [gpg]
      format = ssh
    [commit]
      gpgSign = true
    [tag]
      gpgSign = true
    [url "https://github.com/"]
      insteadOf = git@github.com:
      insteadOf = ssh://git@github.com/
    [credential "https://github.com"]
      helper =
      helper = ${credentialHelper}
      useHttpPath = true
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

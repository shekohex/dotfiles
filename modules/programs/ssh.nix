# SSH with hardware-backed (FIDO2) keys.
#
# The private keys live on the Token2 security keys; ~/.ssh/id_orange and
# ~/.ssh/id_red are only handles. Keys were created touch-only (no
# verify-required) with application ssh:orange / ssh:red. Recreate the
# handles on a new machine (needs the key PIN) with:
#   cd ~/.ssh && ssh-keygen -K
#   mv id_ed25519_sk_rk_orange id_orange   # (and .pub; same for red)
#
# macOS' /usr/bin/ssh has no security-key support, so we install OpenSSH
# from nixpkgs (built with --with-security-key-builtin).
{ pkgs, ... }:

{
  home.packages = [ pkgs.libfido2 ]; # fido2-token, for inspecting the keys

  programs.ssh = {
    enable = true;
    package = pkgs.openssh;
    enableDefaultConfig = false;
    # Reuse one GitHub connection for an hour so pull/push/fetch cost a
    # single touch. Trade-off: while the master is alive, any process running
    # as me can reuse it without a touch.
    settings."github.com" = {
      ControlMaster = "auto";
      ControlPath = "~/.ssh/cm-%C";
      ControlPersist = "1h";
    };
    settings."workstation" = {
      User = "shady";
    };
    settings."raptors-vps" = {
      HostName = "100.100.60.131";
      Port = 2200;
      User = "root";
    };
    settings."winbox" = {
      HostName = "192.168.1.198";
      User = "builder";
    };
    settings."bigboss" = {
      User = "root";
    };
    settings."*" = {
      IdentityFile = [
        "~/.ssh/id_orange"
        "~/.ssh/id_red"
      ];
      AddKeysToAgent = "no";
      ForwardAgent = false;
      HashKnownHosts = true;
      ServerAliveInterval = 60;
    };
  };
}

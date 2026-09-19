{ pkgs, user, ... }:

let
  stateDirectory = "/var/lib/gnome-remote-desktop";
  dataDirectory = "${stateDirectory}/.local/share/gnome-remote-desktop";
  certificatePath = "${dataDirectory}/tls.crt";
  keyPath = "${dataDirectory}/tls.key";
  credentialsPath = "${dataDirectory}/credentials.ini";
  passwordPath = "${stateDirectory}/rdp-password";
  setupScript = pkgs.writeShellScript "gnome-remote-desktop-setup" ''
    set -eu

    if [ ! -s "${passwordPath}" ]; then
      umask 077
      ${pkgs.openssl}/bin/openssl rand -base64 16 > "${passwordPath}"
      ${pkgs.coreutils}/bin/chmod 0600 "${passwordPath}"
    fi

    password=""
    IFS= read -r password < "${passwordPath}" || true

    if [ ! -s "${certificatePath}" ] || [ ! -s "${keyPath}" ]; then
      ${pkgs.coreutils}/bin/rm -f "${certificatePath}" "${keyPath}"
      umask 077
      ${pkgs.openssl}/bin/openssl req \
        -x509 \
        -newkey rsa:4096 \
        -nodes \
        -sha256 \
        -days 3650 \
        -keyout "${keyPath}" \
        -out "${certificatePath}" \
        -subj "/CN=$(${pkgs.hostname}/bin/hostname)"
      ${pkgs.coreutils}/bin/chown gnome-remote-desktop:gnome-remote-desktop "${keyPath}" "${certificatePath}"
      ${pkgs.coreutils}/bin/chmod 0600 "${keyPath}"
      ${pkgs.coreutils}/bin/chmod 0644 "${certificatePath}"
    fi

    credentialsTemporaryPath="${credentialsPath}.tmp"
    printf "[RDP]\ncredentials={'username': <'%s'>, 'password': <'%s'>}\n" \
      "${user}" "$password" > "$credentialsTemporaryPath"
    ${pkgs.coreutils}/bin/chown gnome-remote-desktop:gnome-remote-desktop "$credentialsTemporaryPath"
    ${pkgs.coreutils}/bin/chmod 0600 "$credentialsTemporaryPath"
    ${pkgs.coreutils}/bin/mv -f "$credentialsTemporaryPath" "${credentialsPath}"
  '';
in
{
  services.gnome.gnome-remote-desktop.enable = true;

  networking.firewall.allowedTCPPorts = [ 3389 ];

  systemd.tmpfiles.rules = [
    "d ${stateDirectory} 0700 gnome-remote-desktop gnome-remote-desktop -"
    "d ${stateDirectory}/.local 0700 gnome-remote-desktop gnome-remote-desktop -"
    "d ${stateDirectory}/.local/share 0700 gnome-remote-desktop gnome-remote-desktop -"
    "d ${dataDirectory} 0700 gnome-remote-desktop gnome-remote-desktop -"
    "f ${passwordPath} 0600 root root -"
  ];

  environment.etc."gnome-remote-desktop/grd.conf".text = ''
    [RDP]
    enabled=true
    tls-cert=${certificatePath}
    tls-key=${keyPath}
    port=3389
    auth-methods=credentials
  '';

  systemd.services."gnome-remote-desktop-configuration".wantedBy = [ "graphical.target" ];

  systemd.services."gnome-remote-desktop-setup" = {
    description = "Configure GNOME Remote Desktop credentials and TLS certificate";
    wantedBy = [ "graphical.target" ];
    before = [ "gnome-remote-desktop.service" ];
    after = [
      "dbus.service"
      "systemd-tmpfiles-setup.service"
      "gnome-remote-desktop-configuration.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = setupScript;
    };
  };

  systemd.services."gnome-remote-desktop" = {
    wantedBy = [ "graphical.target" ];
    requires = [ "gnome-remote-desktop-setup.service" ];
    after = [ "gnome-remote-desktop-setup.service" ];
  };
}

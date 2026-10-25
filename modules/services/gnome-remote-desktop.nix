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

  # 3389: Remote Login (system daemon), 3390: Desktop Sharing (user daemon)
  networking.firewall.allowedTCPPorts = [ 3389 3390 ];

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

  # Keep VAAPI (GPU) encoding on for the macOS Windows App:
  # - Never offer AVC444 (always AVC420): the client drops the session
  #   (0x200d) on the first AVC444v2 frame.
  # - Encode limited-range BT.709 (Y 16-235, UV 16-240): the client decodes
  #   the untagged stream as limited range, so full range looks oversaturated.
  nixpkgs.overlays = [
    (final: prev: {
      gnome-remote-desktop = prev.gnome-remote-desktop.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          substituteInPlace src/grd-rdp-dvc-graphics-pipeline.c \
            --replace-fail "*have_avc444 = freerdp_settings_get_bool (rdp_settings, FreeRDP_GfxAVC444v2);" "*have_avc444 = FALSE;"
          substituteInPlace src/shaders/grd-avc-dual-view.comp \
            --replace-fail "return float ((54 * r + 183 * g + 18 * b) >> 8);" "return float (((47 * r + 157 * g + 16 * b) >> 8) + 16);" \
            --replace-fail "return float (((-29 * r - 99 * g + 128 * b) >> 8) + 128);" "return float (((-25 * r - 87 * g + 112 * b) >> 8) + 128);" \
            --replace-fail "return float (((128 * r - 116 * g - 12 * b) >> 8) + 128);" "return float (((112 * r - 102 * g - 10 * b) >> 8) + 128);"
        '';
      });
    })
  ];

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

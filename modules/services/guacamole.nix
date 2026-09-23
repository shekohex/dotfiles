{
  pkgs,
  user,
  lib,
  ...
}:

let
  rdpPasswordPath = "/var/lib/gnome-remote-desktop/rdp-password";
  stateDirectory = "/var/lib/guacamole";
  guacamoleServer = pkgs.guacamole-server.overrideAttrs (previous: {
    patches = (previous.patches or [ ]) ++ [
      ./guacamole-gdi-post-connect.patch
      ./guacamole-plugins.patch
      ./guacamole-h264.patch
      ./guacamole-audio.patch
    ];
  });
  extension = pkgs.stdenvNoCC.mkDerivation {
    pname = "guacamole-auth-json";
    version = "1.6.0";
    src = pkgs.fetchurl {
      url = "https://archive.apache.org/dist/guacamole/1.6.0/binary/guacamole-auth-json-1.6.0.tar.gz";
      hash = "sha256-Sds2Xg1xWXDXhWP62mX0PHb5CO7Q0mcl1LmLBbPfsOk=";
    };
    installPhase = ''
      mkdir -p $out
      cp guacamole-auth-json-1.6.0.jar $out/
    '';
  };
  setup = pkgs.writeShellScript "guacamole-setup" ''
    set -eu
    ${pkgs.coreutils}/bin/install -d -m 0750 -o root -g tomcat ${stateDirectory}
    if [ ! -s ${stateDirectory}/secret-key ]; then
      ${pkgs.openssl}/bin/openssl rand -hex 16 > ${stateDirectory}/secret-key
      ${pkgs.coreutils}/bin/chown root:tomcat ${stateDirectory}/secret-key
      ${pkgs.coreutils}/bin/chmod 0640 ${stateDirectory}/secret-key
    fi
    ${pkgs.coreutils}/bin/install -m 0640 -o root -g tomcat ${rdpPasswordPath} ${stateDirectory}/rdp-password
    IFS= read -r key < ${stateDirectory}/secret-key
    ${pkgs.coreutils}/bin/install -d -m 0755 /etc/guacamole
    ${pkgs.coreutils}/bin/install -m 0640 -o root -g tomcat /dev/null /etc/guacamole/guacamole.properties.tmp
    printf 'guacd-hostname: 127.0.0.1\nguacd-port: 4822\njson-secret-key: %s\n' "$key" > /etc/guacamole/guacamole.properties.tmp
    ${pkgs.coreutils}/bin/mv -f /etc/guacamole/guacamole.properties.tmp /etc/guacamole/guacamole.properties
  '';
  browserGateway = pkgs.writeText "guacamole-browser.py" ''
    import base64
    import hashlib
    import hmac
    import json
    import time
    from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
    from urllib.parse import quote

    from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes


    class BrowserHandler(BaseHTTPRequestHandler):
        def do_GET(self):
            if self.path not in ("/", "/desktop", "/desktop/"):
                self.send_error(404)
                return

            identity = self.headers.get("Tailscale-User-Login")
            if identity != "shekohex@github":
                self.send_error(403)
                return

            with open("${stateDirectory}/secret-key", encoding="ascii") as secret_file:
                key = bytes.fromhex(secret_file.read().strip())
            with open("${stateDirectory}/rdp-password", encoding="ascii") as password_file:
                rdp_password = password_file.read().strip()

            payload = json.dumps({
                "username": "${user}",
                "expires": int(time.time() * 1000) + 12 * 60 * 60 * 1000,
                "connections": {
                    "GNOME Remote Login": {
                        "protocol": "rdp",
                        "parameters": {
                            "hostname": "127.0.0.1",
                            "port": "3389",
                            "username": "${user}",
                            "password": rdp_password,
                            "ignore-cert": "true",
                            "enable-audio-input": "true",
                        },
                    },
                },
            }, separators=(",", ":")).encode()
            signed = hmac.new(key, payload, hashlib.sha256).digest() + payload
            padding = 16 - len(signed) % 16
            encryptor = Cipher(algorithms.AES(key), modes.CBC(bytes(16))).encryptor()
            encrypted = encryptor.update(signed + bytes([padding]) * padding) + encryptor.finalize()
            token = quote(base64.b64encode(encrypted).decode(), safe="")

            self.send_response(302)
            self.send_header("Location", "/guacamole/?data=" + token)
            self.send_header("Cache-Control", "no-store")
            self.send_header("Referrer-Policy", "no-referrer")
            self.end_headers()


    ThreadingHTTPServer(("127.0.0.1", 8079), BrowserHandler).serve_forever()
  '';
in
{
  services.guacamole-client = {
    enable = true;
    settings = { };
  };
  services.guacamole-server = {
    enable = true;
    package = guacamoleServer;
    extraEnvironment.GUACAMOLE_PLUGIN_DIR = "${guacamoleServer}/lib";
  };
  services.tomcat.serverXml = ''
    <Server port="-1">
      <Service name="Catalina">
        <Connector address="127.0.0.1" port="28473" protocol="HTTP/1.1" connectionTimeout="20000" />
        <Engine name="Catalina" defaultHost="localhost">
          <Host name="localhost" appBase="webapps" unpackWARs="true" autoDeploy="true" />
        </Engine>
      </Service>
    </Server>
  '';

  environment.etc."guacamole/extensions/guacamole-auth-json-1.6.0.jar".source =
    "${extension}/guacamole-auth-json-1.6.0.jar";

  systemd.services.guacamole-setup = {
    description = "Configure Guacamole authentication and GNOME RDP access";
    wantedBy = [ "multi-user.target" ];
    requires = [ "gnome-remote-desktop-setup.service" ];
    after = [ "gnome-remote-desktop-setup.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = setup;
    };
  };

  systemd.services.tomcat = {
    requires = [ "guacamole-setup.service" ];
    after = [ "guacamole-setup.service" ];
    preStart = lib.mkAfter ''
      # Tomcat keeps exploded WAR files when the Guacamole WAR symlink changes.
      ${pkgs.coreutils}/bin/rm -rf -- /var/tomcat/webapps/guacamole
    '';
  };

  systemd.services.guacamole-browser = {
    description = "Tailnet GNOME desktop browser entry point";
    wantedBy = [ "multi-user.target" ];
    requires = [ "guacamole-setup.service" ];
    after = [ "guacamole-setup.service" ];
    serviceConfig = {
      User = "tomcat";
      ExecStart = "${
        pkgs.python3.withPackages (pythonPackages: [ pythonPackages.cryptography ])
      }/bin/python ${browserGateway}";
      Restart = "on-failure";
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
    };
  };

  systemd.services.guacamole-tailscale = {
    description = "Serve Guacamole through Tailscale HTTPS";
    wantedBy = [ "multi-user.target" ];
    requires = [
      "tailscaled.service"
      "tomcat.service"
      "guacamole-browser.service"
    ];
    after = [
      "tailscaled.service"
      "tomcat.service"
      "guacamole-browser.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${pkgs.tailscale}/bin/tailscale serve --yes --bg --https=443 --set-path=/guacamole http://127.0.0.1:28473/guacamole"
        "${pkgs.tailscale}/bin/tailscale serve --yes --bg --https=443 --set-path=/desktop http://127.0.0.1:8079"
      ];
    };
  };
}

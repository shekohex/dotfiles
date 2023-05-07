# See darwin/configurations.nix where we enabled gnupg agent
# Here we configure the options itself.

{ lib, pkgs, ... }:

let
  optional = lib.optional;
  enableSshSupport = true;
  defaultCacheTtl = 60480000;
  defaultCacheTtlSsh = 60480000;
  maxCacheTtl = 60480000;
  sshKeys = [ "A61DAE8099822438C17ADB1AEF4439BF5AAFC822" ];
  extraConfig = ''
    pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
    allow-loopback-pinentry
  '';
in
{
  home.file.gpgAgent = {
    enable = pkgs.hostPlatform.isDarwin;
    target = ".gnupg/gpg-agent.conf";
    text = builtins.concatStringsSep "\n"
      (optional (enableSshSupport) "enable-ssh-support"
        ++ optional (defaultCacheTtl != null)
        "default-cache-ttl ${toString defaultCacheTtl}"
        ++ optional (defaultCacheTtlSsh != null)
        "default-cache-ttl-ssh ${toString defaultCacheTtlSsh}"
        ++ optional (maxCacheTtl != null)
        "max-cache-ttl ${toString maxCacheTtl}"
        ++ [ extraConfig ]);
  };

  home.file.sshControl = {
    enable = pkgs.hostPlatform.isDarwin;
    target = ".gnupg/sshcontrol";
    text = lib.concatMapStrings
      (s: ''
        ${s}
      '')
      sshKeys;
  };
}

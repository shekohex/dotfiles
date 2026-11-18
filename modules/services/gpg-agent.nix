{ pkgs, ... }:

{
  services.gpg-agent = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    enableExtraSocket = true;
    enableSshSupport = true;
    defaultCacheTtl = 60480000;
    defaultCacheTtlSsh = 60480000;
    maxCacheTtl = 60480000;
    pinentry.package = pkgs.pinentry-gnome3;
    sshKeys = [ "BCBAB3557E80F8E88442EE406B9608D7B622AE96" ];
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };
}

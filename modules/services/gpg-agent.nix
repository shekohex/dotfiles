{ pkgs, ... }:

{
  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableSshSupport = true;
    defaultCacheTtl = 60480000;
    defaultCacheTtlSsh = 60480000;
    maxCacheTtl = 60480000;
    sshKeys = [ "A61DAE8099822438C17ADB1AEF4439BF5AAFC822" ];
    pinentryFlavor = "tty";
    extraConfig = ''
      pinentry-program ${pkgs.kwalletcli}/bin/pinentry-kwallet
      allow-loopback-pinentry
    '';
  };
}

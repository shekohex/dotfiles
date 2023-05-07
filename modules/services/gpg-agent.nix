{ pkgs, ... }:

{
  services.gpg-agent = {
    enable = pkgs.hostPlatform.isLinux;
    enableExtraSocket = true;
    enableSshSupport = true;
    defaultCacheTtl = 60480000;
    defaultCacheTtlSsh = 60480000;
    maxCacheTtl = 60480000;
    pinentryFlavor = "gnome3";
    sshKeys = [ "A61DAE8099822438C17ADB1AEF4439BF5AAFC822" ];
    extraConfig = ''
      allow-loopback-pinentry
    '';
  };
}

{ pkgs, ... }:

# GPG subkeys live on the Token2 cards (touch required). SSH uses the FIDO2
# keys directly (see modules/programs/ssh.nix), so gpg-agent's SSH support is
# off. Card PINs are cached by scdaemon until the card is removed; these TTLs
# only bound passphrase caching.
{
  services.gpg-agent = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    enableExtraSocket = true;
    enableSshSupport = false;
    defaultCacheTtl = 600;
    maxCacheTtl = 7200;
    pinentry.package = pkgs.pinentry-gnome3;
  };
}

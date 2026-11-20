# See darwin/configuration.nix where we enabled the gnupg agent.
# Here we configure the options itself.
#
# GPG subkeys live on the Token2 cards (touch required). SSH uses the FIDO2
# keys directly (see modules/programs/ssh.nix), so gpg-agent's SSH support is
# off. Card PINs are cached by scdaemon until the card is removed; these TTLs
# only bound passphrase caching.

{ pkgs, ... }:

{
  home.file.gpgAgent = {
    enable = pkgs.stdenv.hostPlatform.isDarwin;
    target = ".gnupg/gpg-agent.conf";
    text = ''
      default-cache-ttl 600
      max-cache-ttl 7200
      pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
    '';
  };

  # Talk to the cards through macOS' PC/SC (CryptoTokenKit) instead of
  # GnuPG's own USB driver, which fights with the OS for the device.
  home.file.scdaemon = {
    enable = pkgs.stdenv.hostPlatform.isDarwin;
    target = ".gnupg/scdaemon.conf";
    text = ''
      disable-ccid
    '';
  };
}

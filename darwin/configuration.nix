{ pkgs, user, ... }:

{

  imports = [
    (import ./system.nix)
    (import ./modules/homebrew)
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixVersions.unstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  nixpkgs.config.allowUnfree = true;

  users.users."${user}" = {
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };

  networking = {
    computerName = "MacBook";
    hostName = "macbook";
    knownNetworkServices = [
      "Wi-Fi"
      "Thunderbolt Bridge"
    ];
    dns = [
      "2a07:a8c0::35:afc4"
      "2a07:a8c1::35:afc4"
      "45.90.28.97"
      "45.90.30.97"
    ];
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      font-awesome
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

  security.pam.enableSudoTouchIdAuth = true;

  environment = {
    shells = [ pkgs.zsh ];
    systemPackages = [
      pkgs.git
      pkgs.gnupg
      pkgs.pinentry_mac
      pkgs.curl
      pkgs.wget
      # Useful Tools
      pkgs.ripgrep
      pkgs.fd
      # Networking
      pkgs.tailscale
    ];
  };

  programs.zsh = {
    enable = true;
  };

  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    nix-daemon.enable = true;
    tailscale = {
      enable = true;
      magicDNS.enable = true;
    };
  };
}

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
      pkgs.ast-grep
      pkgs.fd
      # Networking
      pkgs.tailscale
      pkgs.nextdns
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
    };
  };
}

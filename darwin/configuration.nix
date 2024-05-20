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
    package = pkgs.nixVersions.git;
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
      pkgs.libxml2
      pkgs.libxslt
      pkgs.git
      pkgs.gnupg
      pkgs.pinentry_mac
      pkgs.curl
      pkgs.wget
      pkgs.erdtree
      # Useful Tools
      pkgs.ripgrep
      pkgs.sd
      pkgs.ast-grep
      pkgs.fd
      pkgs.hex
      pkgs.jq
      pkgs.jless
      pkgs.ffmpeg_5-full
      pkgs.xsv
      pkgs.dua
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
    };
  };
}

{ pkgs, user, ... }:

{

  imports = [
    (import ./system.nix)
    (import ./modules/homebrew)
  ] ++ (import ./modules/services);

  nix = {
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
      user = "root";
    };
    optimise.automatic = true;
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
    # fontDir.enable = true;
    packages = with pkgs; [
      font-awesome
      nerd-fonts.jetbrains-mono
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
      pkgs.ffmpeg_7-full
      pkgs.dua
      pkgs.nixd
      pkgs.nixfmt-rfc-style
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

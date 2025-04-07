{ pkgs, user, ... }:

{

  imports = [
    (import ./system.nix)
    (import ./modules/homebrew)
  ] ++ (import ./modules/services);

  nix = {
    enable = true;
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
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
      maple-mono.NF
      font-awesome
      nerd-fonts.jetbrains-mono
    ];
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  environment = {
    shells = [ pkgs.zsh ];
    systemPackages = [
      pkgs.libxml2
      pkgs.libxslt
      pkgs.git
      pkgs.lazygit
      pkgs.gnupg
      pkgs.pinentry_mac
      pkgs.curl
      pkgs.wget
      pkgs.erdtree
      # Useful Tools
      pkgs.ripgrep
      pkgs.fzf
      pkgs.sd
      pkgs.ast-grep
      pkgs.fd
      pkgs.hex
      pkgs.jq
      pkgs.jnv
      pkgs.jless
      pkgs.ffmpeg_7-full
      pkgs.dua
      pkgs.nixd
      pkgs.nixfmt-rfc-style
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

  services = { };
}

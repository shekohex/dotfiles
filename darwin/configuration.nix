{ pkgs, user, ... }:

{
  imports = [
    (import ./system.nix)
    (import ./modules/homebrew)
  ]
  ++ (import ./modules/services);

  # Let the installed Determinate Nix manage Nix and its daemon.
  nix.enable = false;

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
      pkgs.nixfmt
    ];
  };

  programs.zsh = {
    enable = true;
  };

  programs.gnupg = {
    agent = {
      enable = true;
      enableSSHSupport = false;
    };
  };

  services = { };
}

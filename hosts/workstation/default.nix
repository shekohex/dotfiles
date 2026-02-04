{
  pkgs,
  overlays,
  user,
  ...
}:

{
  imports = [
    (import ./hardware-configuration.nix)
  ]
  ++
    # [ (import ../../modules/wm/kde/default.nix) ] ++
    [ (import ../../modules/wm/gnome/default.nix) ]
  ++ (import ../../modules/hardware)
  ++ (import ../../modules/services);

  networking = {
    hostName = "workstation";
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
      timeout = 3;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services = {
    blueman.enable = true;
    pcscd.enable = true;
    tailscale.enable = true;
    pulseaudio.enable = false;
  };

  # Enable docker
  virtualisation.docker = {
    enable = true;
    extraPackages = [ pkgs.docker-buildx ];
  };

  users.users.${user} = {
    extraGroups = [ "docker" ];
    openssh.authorizedKeys.keys = [
      # https://github.com/shekohex.keys
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8YShd1maY40WqeleD8+A9NhE0SyBXoJBUAc6KCBv/J"
    ];
  };

  environment = {
    systemPackages = [
      # System Information
      pkgs.clinfo
      pkgs.virtualgl
      pkgs.vulkan-tools
      # Useful Tools
      pkgs.ripgrep
      pkgs.sd
      pkgs.ast-grep
      pkgs.fd
      pkgs.hex
      pkgs.jq
      pkgs.jnv
      pkgs.jless
      # For Tailscale Networking
      pkgs.tailscale
      pkgs.cloudflared
      # Development Tools
      pkgs.mise
      pkgs.openjdk
      pkgs.dotnet-sdk
      pkgs.ruby
      pkgs.wakeonlan
      pkgs.eternal-terminal
      pkgs.ntfy
      pkgs.tea
      pkgs.pgcli
      pkgs.terraform
      pkgs.coder
      pkgs.bun
    ];
    variables = { };
    sessionVariables = {
      # NIXOS_OZONE_WL = "1";
    };
    pathsToLink = [ "/share/zsh" ];
  };

}

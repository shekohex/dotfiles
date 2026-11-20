{
  pkgs,
  overlays,
  user,
  ...
}:

{
  imports = [
    (import ./hardware-configuration.nix)
    (import ./net-usage.nix)
    (import ../../modules/wm/gnome/default.nix)
    # Disabled: Niri window manager.
    # (import ../../modules/wm/niri/default.nix)
  ]
  ++ (import ../../modules/hardware)
  ++ (import ../../modules/services);

  networking = {
    hostName = "workstation";
    networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
    firewall.extraCommands = ''
      iptables -A nixos-fw -s 192.168.1.0/24 -j nixos-fw-accept
    '';
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
    # Only keys declared in this repo may log in; ~/.ssh/authorized_keys is ignored.
    openssh.authorizedKeysInHomedir = false;
    # Let my user talk to FIDO2 security keys (SSH ed25519-sk).
    udev.packages = [ pkgs.libfido2 ];
    tailscale.enable = true;
    pulseaudio.enable = false;
  };

  # udev rules so GnuPG can use the OpenPGP smartcards (Token2 keys).
  hardware.gpgSmartcards.enable = true;

  # Enable docker
  virtualisation.docker = {
    enable = true;
    extraPackages = [ pkgs.docker-buildx ];
  };

  users.users.${user} = {
    extraGroups = [ "docker" ];
    openssh.authorizedKeys.keys = [
      # https://github.com/shekohex.keys
      # Hardware-backed (FIDO2) keys on the Token2 security keys.
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAINGaoVtGGsnInW0NbFIfbMkhtvB+2TXfpwkvzVobkOdUAAAACnNzaDpvcmFuZ2U= shekohex-orange"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAICzUU/bBD/F5qzv+1VmFOVrSM70ERELL56AO9DVpJKU3AAAAB3NzaDpyZWQ= shekohex-red"
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
      (with pkgs.dotnetCorePackages; combinePackages [
        sdk_10_0
        sdk_9_0
      ])
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

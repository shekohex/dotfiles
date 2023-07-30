{ pkgs, overlays, user, ... }:

{
  imports =
    [ (import ./hardware-configuration.nix) ] ++
    # [ (import ../../modules/wm/kde/default.nix) ] ++
    [ (import ../../modules/wm/gnome/default.nix) ] ++
    (import ../../modules/hardware);

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

  hardware = {
    pulseaudio.enable = false;
  };

  services = {
    blueman.enable = true;
    pcscd.enable = true;
    tailscale.enable = true;
    nextdns = {
      enable = true;
      arguments = [
        "-auto-activate"
        "-profile"
        "35afc4"
        "-cache-size"
        "10MB"
      ];
    };
  };

  # Enable docker
  virtualisation.docker = {
    enable = true;
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
      pkgs.ast-grep
      pkgs.fd
      pkgs.hex
      # For Tailscale Networking
      pkgs.tailscale
      pkgs.nextdns
    ];
    variables = { };
    sessionVariables = {
      # NIXOS_OZONE_WL = "1";
    };
  };

  nixpkgs.overlays = overlays ++ [ ];
}

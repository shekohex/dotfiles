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
  };

  hardware = {
    pulseaudio.enable = false;
  };

  services = {
    blueman.enable = true;
    pcscd.enable = true;
    tailscale.enable = true;
  };

  # Enable docker
  virtualisation.docker = {
    enable = true;
  };
  users.users.${user}.extraGroups = [ "docker" ];
  environment = {
    systemPackages = [
      # System Information
      pkgs.clinfo
      pkgs.virtualgl
      pkgs.vulkan-tools
      # Useful Tools
      pkgs.ripgrep
      pkgs.fd
      # For Tailscale Networking
      pkgs.tailscale
    ];
    variables = { };
    sessionVariables = {
      # NIXOS_OZONE_WL = "1";
    };
  };

  nixpkgs.overlays = overlays ++ [ ];
}

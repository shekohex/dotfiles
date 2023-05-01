{ pkgs, lib, user, overlays, ... }:

{
  imports =
    [ (import ./hardware-configuration.nix) ] ++
    [ (import ../../modules/wm/kde/default.nix) ] ++
    (import ../../modules/hardware);

  networking.hostName = "workstation";
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

  environment = {
    systemPackages = [
      # Useful Tools
      pkgs.cachix
      pkgs.ripgrep
      pkgs.fd
    ];
    variables = { };
  };

  services = {
    blueman.enable = true;
    pcscd.enable = true;
  };

  nixpkgs.overlays = overlays ++ [ ];
}

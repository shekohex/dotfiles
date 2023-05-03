{ lib, nixpkgs, home-manager, user, nixneovimplugins, ... }:

let
  system = "x86_64-linux";
  overlays = [ nixneovimplugins.overlays.default ];
  pkgs = import nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
  };
in
{
  workstation = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit overlays user system;
      host = {
        hostName = "workstation";
      };
    };

    modules = [
      ./workstation
      ./configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit overlays user pkgs;
        };
        home-manager.users.${user} = {
          imports = [
            ./home.nix
            ./workstation/home.nix
          ];
        };
      }
    ];
  };
}

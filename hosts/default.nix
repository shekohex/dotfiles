{ lib, nur, nixpkgs, home-manager, user, nixneovimplugins, zen-browser, nix-vscode-extensions, ... }:

let
  system = "x86_64-linux";
  overlays = [
    nixneovimplugins.overlays.default
    nur.overlays.default
    nix-vscode-extensions.overlays.default
  ];
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
      host = { hostName = "workstation"; };
    };

    modules = [
      nur.modules.nixos.default
      ./workstation
      ./configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit system overlays user pkgs nur zen-browser;
        };
        home-manager.users.${user} = {
          imports = [
            nur.modules.homeManager.default
            ./home.nix
            ./workstation/home.nix
          ];
        };
      }
    ];
  };
}

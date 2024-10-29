{ lib, nixpkgs, home-manager, darwin, firefox-darwin, nur, nixneovimplugins, user, ... }:

let
  system = "aarch64-darwin";
  overlays = [
    nixneovimplugins.overlays.default
    firefox-darwin.overlay
    nur.overlay
  ];
  pkgs = import nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
  };
in
{
  macbook = darwin.lib.darwinSystem {
    inherit system;
    specialArgs = {
      inherit system overlays user;
    };

    modules = [
      ./configuration.nix
      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user overlays pkgs;
        };
        home-manager.users.${user} = import ./home.nix;
      }
    ];
  };
}

{
  lib,
  nixpkgs,
  home-manager,
  darwin,
  firefox-darwin,
  nur,
  nixneovimplugins,
  fff-nvim,
  user,
  nix-vscode-extensions,
  ...
}:

let
  system = "aarch64-darwin";
  overlays = [
    nixneovimplugins.overlays.default
    firefox-darwin.overlay
    nur.overlays.default
    nix-vscode-extensions.overlays.default
    (final: prev: {
      vimPlugins = prev.vimPlugins // {
        fff-nvim = fff-nvim.packages.${system}.fff-nvim;
      };
    })
  ];
  pkgs = import nixpkgs {
    inherit system overlays;
    config.allowUnfree = true;
  };
in
{
  macbook = darwin.lib.darwinSystem {
    inherit system;
    specialArgs = { inherit system overlays user; };

    modules = [
      { nixpkgs.config.allowUnfree = true; }
      ./configuration.nix
      home-manager.darwinModules.home-manager
      {
        home-manager.backupFileExtension = "bak";
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user overlays pkgs; };
        home-manager.users.${user} = import ./home.nix;
      }
    ];
  };
}

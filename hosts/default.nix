{
  lib,
  nur,
  nixpkgs,
  home-manager,
  user,
  nixneovimplugins,
  zen-browser,
  nix-vscode-extensions,
  vscode-server,
  opencode,
  ...
}:

let
  system = "x86_64-linux";
  overlays = [
    nixneovimplugins.overlays.default
    nur.overlays.default
    nix-vscode-extensions.overlays.default
    (import ../overlays/opencode.nix { inherit opencode; })
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
      host = {
        hostName = "workstation";
      };
    };

    modules = [
      { nixpkgs.config.allowUnfree = true; }
      nur.modules.nixos.default
      vscode-server.nixosModules.default
      ./workstation
      ./configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "bak";
        home-manager.extraSpecialArgs = {
          inherit
            system
            overlays
            user
            pkgs
            nur
            zen-browser
            ;
        };
        home-manager.users.${user} = {
          imports = [
            nur.modules.homeManager.default
            vscode-server.homeModules.default
            ./home.nix
            ./workstation/home.nix
          ];
        };
      }
    ];
  };
}

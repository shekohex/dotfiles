{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devenv.url = "github:cachix/devenv";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "nixpkgs";
    };

    nixneovimplugins = {
      url = "github:NixNeovim/NixNeovimPlugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, plasma-manager, flake-utils, devenv, nixneovimplugins, ... } @ inputs:
    let
      user = "shady";
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit nixpkgs home-manager user plasma-manager nixneovimplugins;
        }
      );
    } //
    # devShells
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.packages.${system};
      in
      {
        devShell = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            ({ pkgs, ... }: {
              # This is your devenv configuration
              packages = [
                pkgs.nodejs
                pkgs.yarn
                pkgs.rustup
                pkgs.clang
                pkgs.gnumake
                pkgs.nixpkgs-fmt
              ];
            })
          ];
        };
      });
}


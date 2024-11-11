{
  description = "My Nix configuration & dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
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

    zed-editor = {
      url = "github:zed-industries/zed/v0.161.1-pre";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs
    , nur
    , home-manager
    , darwin
    , firefox-darwin
    , plasma-manager
    , nixneovimplugins
    , zen-browser
    , zed-editor
    , ...
    }:
    let
      user = "shady";
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit nixpkgs nur home-manager user plasma-manager nixneovimplugins zen-browser zed-editor;
        }
      );
      darwinConfigurations = (
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit nixpkgs nur home-manager darwin firefox-darwin user nixneovimplugins;
        }
      );
    };
}


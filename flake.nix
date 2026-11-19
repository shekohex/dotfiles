{
  description = "My Nix configuration & dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hex = {
      # Latest upstream Rune app plus our cloud/realtime providers; old branch stays reference-only.
      url = "git+file:///home/shady/github/shekohex/hex?ref=feat/linux-cloud-latest";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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

    helium-browser = {
      url = "github:oxcl/nix-flake-helium-browser";
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

    fff-nvim = {
      url = "github:dmtrKovalenko/fff.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disabled: uncomment dependent overlays/modules to re-enable VS Code.
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";

  };

  outputs =
    {
      nixpkgs,
      llm-agents,
      nur,
      home-manager,
      hex,
      darwin,
      firefox-darwin,
      plasma-manager,
      nixneovimplugins,
      fff-nvim,
      zen-browser,
      helium-browser,
      nix-vscode-extensions,
      vscode-server,
      ...
    }:
    let
      user = "shady";
    in
    {
      apps = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          updater = pkgs.writeShellApplication {
            name = "update-t3code";
            runtimeInputs = [ pkgs.gh pkgs.python3 ];
            text = ''
              exec python3 ${./scripts/t3code-release.py} --update "$@"
            '';
          };
        in
        {
          update-t3code = {
            type = "app";
            program = nixpkgs.lib.getExe updater;
            meta.description = "Update T3 Code release pins in the local dotfiles";
          };
        }
      );

      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit
            nixpkgs
            llm-agents
            nur
            home-manager
            hex
            user
            plasma-manager
            nixneovimplugins
            fff-nvim
            zen-browser
            helium-browser
            nix-vscode-extensions
            vscode-server
            ;
        }
      );
      darwinConfigurations = (
        import ./darwin {
          inherit (nixpkgs) lib;
          user = "shekohex";
          inherit
            nixpkgs
            llm-agents
            nur
            home-manager
            darwin
            firefox-darwin
            nixneovimplugins
            fff-nvim
            nix-vscode-extensions
            ;
        }
      );
    };
}

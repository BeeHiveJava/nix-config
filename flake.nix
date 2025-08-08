{
  inputs = {
    # nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # home-manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # System
    systems.url = "github:nix-systems/default-linux";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # misc
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      systems,
      treefmt-nix,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;

      # Generate attrset for each system
      forAllSystems = lib.genAttrs (import systems);

      # Input packages for each system
      inputPkgsFor =
        pkgs:
        forAllSystems (
          system:
          import pkgs {
            inherit system;
            config.allowUnfree = true;
            config.allowUnfreePredicate = _: true; # https://github.com/nix-community/home-manager/issues/2942
          }
        );

      # Nixpkgs for each system
      nixpkgsFor = inputPkgsFor nixpkgs;

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = forAllSystems (system: treefmt-nix.lib.evalModule nixpkgsFor.${system} ./treefmt.nix);

      # SpecialArgs that share between nixosConfig and homeConfig
      specialArgs = forAllSystems (system: {
        inherit inputs outputs;
        self = self;
        pkgs-stable = (inputPkgsFor inputs.nixpkgs-stable).${system};
      });

      nixosConfig =
        { modules, system }:
        lib.nixosSystem {
          pkgs = nixpkgsFor.${system};
          specialArgs = specialArgs.${system};

          modules = modules ++ [
            outputs.nixosModules
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                sharedModules = [ outputs.homeManagerModules ];
                extraSpecialArgs = specialArgs.${system};
              };
            }
          ];
        };

      homeConfig =
        { modules, system }:
        lib.homeManagerConfiguration {
          pkgs = nixpkgsFor.${system};
          extraSpecialArgs = specialArgs.${system};
          modules = modules ++ [ outputs.homeManagerModules ];
        };
    in
    {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#nixos'
      nixosConfigurations = {
        nixos = nixosConfig {
          modules = [ ./hosts/wsl ];
          system = "x86_64-linux";
        };
      };

      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);

      devShells = forAllSystems (
        system:
        import ./shell.nix {
          pkgs = nixpkgsFor.${system};
          pre-commit-check = self.checks.${system}.pre-commit-check;
        }
      );

      checks = forAllSystems (system: {
        formatting = treefmtEval.${system}.config.build.check self;
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            treefmt = {
              enable = true;
              package = treefmtEval.${system}.config.build.wrapper;
            };

            eclint = {
              enable = true;
            };

            yamllint = {
              enable = true;
            };
          };
        };
      });
    };
}

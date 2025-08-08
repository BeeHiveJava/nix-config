{
  inputs = {
    # nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # home-manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # System
    systems.url = "github:nix-systems/default-linux";

    nixos-wsl.url = "github:nix-community/nixos-wsl/release-25.05";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    systems,
    agenix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    forEachSystem = f: lib.genAttrs (import systems) (system: f forEachSystemPkgs.${system});
    forEachSystemPkgs = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.allowUnfreePredicate = _: true; # https://github.com/nix-community/home-manager/issues/2942
        }
    );
  in {
    inherit lib;
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    nixosConfigurations = {
      nixos = lib.nixosSystem {
        modules = [./vars/hosts/wsl outputs.nixosModules];
        specialArgs = {inherit inputs outputs;};
        pkgs = forEachSystemPkgs.x86_64-linux;
      };
    };

    homeConfigurations = {
      "bee@nixos" = lib.homeManagerConfiguration {
        modules = [./vars/homes/bee outputs.homeManagerModules];
        extraSpecialArgs = {inherit inputs outputs;};
        pkgs = forEachSystemPkgs.x86_64-linux;
      };
    };
  };
}

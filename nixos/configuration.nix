{ config, inputs, lib, ... }: {
  imports = [
    ./wsl.nix
    ./networking.nix
    ./users.nix
    ./xfce.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";

      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
  };

  system.stateVersion = "24.05";
}

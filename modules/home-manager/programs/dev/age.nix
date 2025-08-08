{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.dev.age;
in {
  options.programs.dev.age = {
    enable = mkEnableOption "age";

    identityPaths = mkOption {
      type = types.listOf types.path;
      description = "Paths defining SSH keys used for secret management";
    };
  };

  imports = [inputs.agenix.homeManagerModules.default];

  config = mkIf cfg.enable {
    home.packages = [inputs.agenix.packages.${pkgs.system}.default];

    age = {
      identityPaths = cfg.identityPaths;
    };
  };
}

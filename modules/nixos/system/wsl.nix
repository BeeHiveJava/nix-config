{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.system.wsl;
in {
  options.system.wsl = {
    enable = mkEnableOption "git";

    docker.enable = mkOption {
      type = types.bool;
      description = "Enable Docker integration";
      default = true;
    };

    defaultUser = mkOption {
      type = types.str;
      description = "Default user";
    };
  };

  imports = [inputs.nixos-wsl.nixosModules.default];

  config = mkIf cfg.enable (mkMerge [
    {
      wsl = {
        enable = cfg.enable;
        defaultUser = cfg.defaultUser;
      };
    }

    {
      # https://nix-community.github.io/NixOS-WSL/how-to/vscode.html#option-1-set-up-nix-ld
      programs.nix-ld.enable = cfg.enable;
    }

    # [See this](https://github.com/nix-community/NixOS-WSL/issues/235#issuecomment-1937424376)
    (mkIf cfg.docker.enable {
      wsl = {
        # Enable integration with Docker Desktop (needs to be installed)
        docker-desktop.enable = cfg.enable;

        # Binaries for Docker Desktop wsl-distro-proxy
        extraBin = with pkgs; [
          {src = "${coreutils}/bin/mkdir";}
          {src = "${coreutils}/bin/cat";}
          {src = "${coreutils}/bin/whoami";}
          {src = "${coreutils}/bin/ls";}
          {src = "${busybox}/bin/addgroup";}
          {src = "${su}/bin/groupadd";}
          {src = "${su}/bin/usermod";}
        ];
      };

      users.users.${cfg.defaultUser}.extraGroups = ["docker"];
    })
  ]);
}

{
  self,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkDefault
    mkMerge
    types
    optional
    ;
  cfg = config.users.bee;

  username = "bee";

  ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  imports = [ self.inputs.sops-nix.nixosModules.sops ];

  options.users.${username} = {
    enable = mkEnableOption "user ${username}";

    home-manager = mkOption {
      type = types.bool;
      description = "Enable home-manager for this user.";
      default = true;
    };

    secrets = mkOption {
      type = types.bool;
      description = "Enable sops for this user.";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    nix.settings.trusted-users = [ username ];

    users.users.${username} = mkMerge [
      {
        home = mkDefault "/home/${username}";
        shell = pkgs.bashInteractive;
        isNormalUser = true;

        extraGroups = ifGroupExist [
          "wheel"
          "networkmanager"
          "docker"
          "podman"
          "libvirtd"
        ];
      }
    ];

    home-manager.users = mkIf cfg.home-manager {
      ${username} = {
        imports = [ (import "${self}/users/${username}") ];
        _module.args.secrets = if cfg.secrets then config.sops.secrets else { };
      };
    };

    sops = mkIf cfg.secrets {
      age = {
        keyFile = /var/lib/sops-nix/keys.txt;
      };

      secrets =
        let
          hostSecrets = {
            sopsFile = "${self}/users/${username}/secrets.yaml";
            owner = username;
          };
        in
        {
          git_public_key = hostSecrets;
          git_private_key = hostSecrets;
        };
    };

    environment.systemPackages = mkIf cfg.secrets (
      with pkgs;
      [
        pkgs.sops
        pkgs.age
        pkgs.ssh-to-age
      ]
    );

    systemd.services = mkIf (cfg.secrets && cfg.home-manager) {
      "home-manager-${username}" = {
        after = [ "sops-install-secrets.service" ];
        wants = [ "sops-install-secrets.service" ];
      };
    };
  };
}

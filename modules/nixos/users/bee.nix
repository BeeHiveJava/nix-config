{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.users.bee;

  username = "bee";

  ifGroupExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  options.users.${username} = {
    enable = mkEnableOption "user ${username}";

    home-manager = mkOption {
      type = types.bool;
      description = "Enable home-manager for this user";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    nix.settings.trusted-users = [username];

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
  };
}

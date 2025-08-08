{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.dev.ssh;
in {
  options.programs.dev.ssh = {
    enable = mkEnableOption "ssh";

    publicKey = mkOption {
      type = types.nullOr types.path;
      description = "Path to public SSH key secret";
      default = null;
    };

    privateKey = mkOption {
      type = types.nullOr types.path;
      description = "Path to private SSH key secret";
      default = null;
    };
  };

  config = mkIf cfg.enable {
    programs.ssh.enable = cfg.enable;

    age.secrets.ssh_public_key = mkIf (cfg.publicKey != null) {
      file = cfg.publicKey;
      path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
    };

    age.secrets.ssh_private_key = mkIf (cfg.privateKey != null) {
      file = cfg.privateKey;
      path = "${config.home.homeDirectory}/.ssh/id_ed25519";
    };
  };
}

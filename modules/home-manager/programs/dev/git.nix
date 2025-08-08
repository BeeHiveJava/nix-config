{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.dev.git;
in {
  options.programs.dev.git = {
    enable = mkEnableOption "git";

    name = mkOption {
      type = types.str;
      description = "Git user name";
    };

    email = mkOption {
      type = types.str;
      description = "Git user email";
    };

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
    age.secrets.git_public_key = mkIf (cfg.publicKey != null) {
      file = cfg.publicKey;
      path = "${config.home.homeDirectory}/.ssh/git.pub";
    };

    age.secrets.git_private_key = mkIf (cfg.privateKey != null) {
      file = cfg.privateKey;
      path = "${config.home.homeDirectory}/.ssh/git";
    };

    programs.git = {
      enable = cfg.enable;

      userName = cfg.name;
      userEmail = cfg.email;

      aliases = {
        a = "add .";

        c = "commit";
        ca = "commit --amend --no-edit";
        cap = "!git commit --amend --no-edit && git push --force";

        p = "push";
        pf = "push --force";
      };

      extraConfig = {
        user = mkIf (cfg.privateKey != null) {
          signingkey = "${config.home.homeDirectory}/.ssh/git";
        };

        gpg = mkIf (cfg.privateKey != null) {
          format = "ssh";
        };

        commit = mkIf (cfg.privateKey != null) {
          gpgsign = true;
        };

        tag = mkIf (cfg.privateKey != null) {
          gpgsign = true;
        };

        push = {
          default = "current";
          autoSetupRemote = true;
          followTags = true;
        };

        pull = {
          default = "current";
          rebase = true;
        };
      };
    };
  };
}

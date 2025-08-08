{
  self,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.programs.dev.git;
in
{
  options.programs.dev.git = {
    enable = mkEnableOption "git";

    name = mkOption {
      type = types.str;
      description = "Git user name.";
    };

    email = mkOption {
      type = types.str;
      description = "Git user email.";
    };

    privateKey = mkOption {
      type = types.nullOr types.path;
      description = "Private SSH key for git signing.";
      default = null;
    };

    publicKey = mkOption {
      type = types.nullOr types.path;
      description = "Public SSH key for git signing.";
      default = null;
    };
  };

  config = mkIf cfg.enable {
    home.file.".ssh/git" = mkIf (cfg.privateKey != null) {
      source = cfg.privateKey;
    };

    home.file.".ssh/git.pub" = mkIf (cfg.publicKey != null) {
      source = cfg.publicKey;
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

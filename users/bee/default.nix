{ secrets, ... }:
let
  hasGitSecrets = (secrets ? git_public_key) && (secrets ? git_private_key);
in
{
  home.stateVersion = "25.05";
  home = {
    username = "bee";
    homeDirectory = "/home/bee";
  };

  programs = {
    dev = {
      git = {
        enable = true;
        name = "BeeHiveJava";
        email = "BeeHiveJava@users.noreply.github.com";
        publicKey = if hasGitSecrets then secrets.git_public_key.path else null;
        privateKey = if hasGitSecrets then secrets.git_private_key.path else null;
      };

      ssh = {
        enable = true;
      };
    };
  };
}

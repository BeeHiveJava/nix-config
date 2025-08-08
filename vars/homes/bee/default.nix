{config, ...}: {
  home.stateVersion = "25.05";
  home = {
    username = "bee";
    homeDirectory = "/home/bee";
  };

  programs = {
    dev = {
      age = {
        enable = (builtins.getEnv "DISABLE_SECRETS") != "1";
        identityPaths = [/etc/ssh/wsl];
      };

      git = {
        enable = true;
        name = "BeeHiveJava";
        email = "BeeHiveJava@users.noreply.github.com";
        publicKey = ./secrets/git_public_key.age;
        privateKey = ./secrets/git_private_key.age;
      };

      ssh = {
        enable = true;

        publicKey = ./secrets/ssh_public_key.age;
        privateKey = ./secrets/ssh_private_key.age;
      };
    };
  };
}

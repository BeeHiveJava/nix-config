{
  networking.hostName = "nixos";
  time.timeZone = "Europe/Amsterdam";

  system.stateVersion = "25.05";
  system = {
    wsl = {
      enable = true;
      defaultUser = "bee";
    };
  };

  users.bee = {
    enable = true;
    secrets = builtins.getEnv "DISABLE_SECRETS" != "1";
  };
}

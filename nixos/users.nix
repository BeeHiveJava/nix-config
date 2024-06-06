{ ... }: {
  users.users = {
    lesley = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker"];
      initialPassword = "changeme";
    };
  };
}

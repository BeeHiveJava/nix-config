{ ... }: {
  users.users = {
    lesley = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      initialPassword = "changeme";
    };
  };
}

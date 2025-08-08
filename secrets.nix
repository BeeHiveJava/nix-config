let
  # User Secrets
  bee = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFz3LZT/WFBEPXmhcp+trzdZEcfwgEajknwVlP0P/WP4";
  users = [bee];

  # System Secrets
  wsl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVEVsZzHaJFka5kGwOqAt3iDGoQnEMSBBT8UPzt1Qau";
  systems = [wsl];

  # All Secrets
  all = users ++ systems;

  # Helpers
  mkSecret = user: name: {
    "vars/users/${user}/secrets/${name}.age" = {
      publicKeys = all;
      armor = true;
    };
  };
  mkSecrets = user: names: builtins.foldl' (acc: name: acc // (mkSecret user name)) {} names;
in
  mkSecrets "bee" [
    "ssh_public_key"
    "ssh_private_key"
    "git_public_key"
    "git_private_key"
  ]

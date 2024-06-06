{ ... }: {
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "lesley";

  nixpkgs.hostPlatform = "x86_64-linux";
}

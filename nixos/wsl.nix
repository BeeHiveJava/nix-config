{ config, lib, pkgs, ... }: {
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl = {
    enable = true;
    defaultUser = "lesley";

    extraBin = with pkgs; [
      # Binaries for Docker Desktop wsl-distro-proxy
      # https://github.com/nix-community/NixOS-WSL/issues/235#issuecomment-1937424376
      { src = "${coreutils}/bin/mkdir"; }
      { src = "${coreutils}/bin/cat"; }
      { src = "${coreutils}/bin/whoami"; }
      { src = "${coreutils}/bin/ls"; }
      { src = "${busybox}/bin/addgroup"; }
      { src = "${su}/bin/groupadd"; }
      { src = "${su}/bin/usermod"; }
    ];
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}

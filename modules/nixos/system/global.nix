{pkgs, ...}: {
  nix.package = pkgs.nix;
  nix = {
    channel.enable = false;

    settings = {
      warn-dirty = false;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}

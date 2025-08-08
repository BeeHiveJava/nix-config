{ pkgs, pre-commit-check, ... }:
{
  default = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      git

      sops
      age
      ssh-to-age
    ];

    shellHook = pre-commit-check.shellHook;
    buildInputs = pre-commit-check.enabledPackages;
  };
}

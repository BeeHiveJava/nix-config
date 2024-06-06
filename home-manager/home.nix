{ ... }: {
  imports = [
    ./i3.nix
    ./rofi.nix
    ./wezterm.nix
    ./git.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true; # https://github.com/nix-community/home-manager/issues/2942
    };
  };

  home = {
    username = "lesley";
    homeDirectory = "/home/lesley";
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05";
}

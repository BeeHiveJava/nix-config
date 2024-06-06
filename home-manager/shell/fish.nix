{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # Greeting
      set -g fish_greeting

      # Starship
      starship init fish | source

      # TheFuck
      thefuck --alias | source

      # Fzf
      set fzf_fd_opts --hidden --exclude=.git --exclude=.cache
      set fzf_preview_file_cmd bat
      set fzf_preview_dir_cmd eza --all --color=always

      fzf_configure_bindings \
        --git_log=\cg \
        --git_status=\cs \
        --variables=\ce \
        --directory=\cf \
        --history=\ch
    '';

    plugins = [
      { name = "git-abbr"; src = pkgs.fishPlugins.git-abbr.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "puffer"; src = pkgs.fishPlugins.puffer.src; }
      {
        name = "fish-abbreviation-tips";
        src = pkgs.fetchFromGitHub {
          owner = "gazorby";
          repo = "fish-abbreviation-tips";
          rev = "v0.7.0";
          sha256 = "F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
        };
      }
    ];

    shellAliases = {
      ls = "eza";
      cat = "bat";
      docker = "/usr/bin/docker";
    };

    shellAbbrs = {
      fu = "fuck";
    };

    functions = {
      update-all = "update-system && update-home";
      update-system = "cd-config && git pull --rebase && sh nixos-system.sh && cd -";
      update-home = "cd-config && git pull --rebase && sh nixos-home.sh && cd -";
      cd-config = "cd $HOME/.config/nix-config";
    };
  };

  programs.bat.enable = true;
  programs.eza.enable = true;
  programs.fd.enable = true;
  programs.fzf.enable = true;
  programs.thefuck.enable = true;
}

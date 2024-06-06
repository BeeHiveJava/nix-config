{ ... }:

{
  programs.wezterm = {
    enable = true;
  };

  xdg.configFile."wezterm/wezterm.lua".source = ./config/wezterm.lua;
  xdg.configFile."wezterm/appearance.lua".source = ./config/appearance.lua;
  xdg.configFile."wezterm/keybindings.lua".source = ./config/keybindings.lua;
}

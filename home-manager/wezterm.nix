{ ... }:

{
  programs.wezterm = {
    enable = true;
  };

  xdg.configFile."wezterm/wezterm.lua".source = ./config/wezterm/wezterm.lua;
  xdg.configFile."wezterm/appearance.lua".source = ./config/wezterm/appearance.lua;
  xdg.configFile."wezterm/keybindings.lua".source = ./config/wezterm/keybindings.lua;
}

local wezterm = require "wezterm"
local module = {}

local function scheme_for_appearance(appearance)
    if appearance:find "Dark" then
        return "Catppuccin Macchiato"
    else
        return "Catppuccin Latte"
    end
  end

function module.apply_to_config(config)
    config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
    config.font = wezterm.font("Fira Code", { weight = "Medium" })
    config.font_size = 12.0

    config.window_decorations = "RESIZE"
    config.window_background_opacity = 0.8
    config.hide_tab_bar_if_only_one_tab = true
end

return module

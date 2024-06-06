local wezterm = require "wezterm"
local appearance = require "appearance"
local keybindings = require "keybindings"

local config = wezterm.config_builder()
appearance.apply_to_config(config)
keybindings.apply_to_config(config)
return config

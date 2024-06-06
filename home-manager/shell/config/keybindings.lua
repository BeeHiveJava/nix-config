local wezterm = require "wezterm"
local module = {}

function module.apply_to_config(config)
    config.keys = {
        {
            key = "_",
            mods = "CTRL|SHIFT",
            action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
        },
        {
            key = "+",
            mods = "CTRL|SHIFT",
            action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
        },
        {
            key = "W",
            mods = "CTRL|SHIFT",
            action = wezterm.action.CloseCurrentPane { confirm = true },
        },
        {
            key = 'l',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.ShowLauncher
        },
    }
end

return module

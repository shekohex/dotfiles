local wezterm = require 'wezterm'
local M = {}

M.font = wezterm.font('Iosevka Nerd Font')
M.font_size = 18
M.color_scheme = 'Gruvbox Light'
M.default_cursor_style = "BlinkingUnderline"
M.audible_bell = "Disabled"
M.enable_tab_bar = true
M.use_fancy_tab_bar = true
M.hide_tab_bar_if_only_one_tab = true
M.window_decorations = "RESIZE"
M.window_close_confirmation = "NeverPrompt"
M.use_resize_increments = true
M.window_background_opacity = 0.98
M.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10
}
M.use_ime = false
M.window_frame = {
    active_titlebar_bg = "#d5c4a1",
    button_bg = "#282828",
}

M.colors = {
    tab_bar = {
        -- The color of the strip that goes along the top of the window
        -- (does not apply when fancy tab bar is in use)
        background = "#d5c4a1",
        active_tab = {
            bg_color = "#fbf1c7",
            fg_color = "#282828",
            intensity = "Bold",
            underline = "None",
            italic = false,
            strikethrough = false,
        },
        inactive_tab = {
            bg_color = "#d5c4a1",
            fg_color = "#665c54",
        },
        inactive_tab_hover = {
            bg_color = "#282828",
            fg_color = "#fbf1c7",
            italic = true,
        },
        new_tab = {
            bg_color = "#7c6f64",
            fg_color = "#fbf1c7",
        },
        new_tab_hover = {
            bg_color = "#282828",
            fg_color = "#fbf1c7",
            italic = true,
        }
    }
}

M.ssh_domains = {
    {
        name = "workstation",
        remote_address = "workstation",
        local_echo_threshold_ms = 8,
    },
}
return M;

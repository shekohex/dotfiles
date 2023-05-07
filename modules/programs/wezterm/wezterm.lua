local wezterm = require("wezterm")
local mux = wezterm.mux

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 16
config.default_cursor_style = "BlinkingUnderline"
config.audible_bell = "Disabled"
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 32
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.use_resize_increments = true
config.window_background_opacity = 1
config.native_macos_fullscreen_mode = true
config.window_padding = {
  left = 15,
  right = 15,
  top = 15,
  bottom = 5,
}
config.use_ime = false
config.enable_wayland = false
config.enable_csi_u_key_encoding = true

local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

local brighteness = "Dark"
config.color_scheme = scheme_for_appearance(brighteness)

config.ssh_domains = {
  {
    name = "workstation",
    remote_address = "workstation",
    assume_shell = "Posix",
    local_echo_threshold_ms = 80,
  },
}

config.unix_domains = {
  {
    name = "unix",
  },
}

config.default_gui_startup_args = { "connect", "unix" }

return config

local wezterm = require("wezterm")
local mux = wezterm.mux

local is_linux = wezterm.target_triple:find("linux")
local is_macos = wezterm.target_triple:find("darwin")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font = wezterm.font_with_fallback({
  {
    family = "JetBrainsMono Nerd Font",
    harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
    assume_emoji_presentation = false,
  },
  { family = "Times New Roman",  assume_emoji_presentation = false },
  { family = "DejaVu Sans Mono", assume_emoji_presentation = false },
})

config.font_size = is_macos and 20 or 16
config.default_cursor_style = "BlinkingUnderline"
config.audible_bell = "Disabled"
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 32
-- Hide window decorations on Linux only
config.window_decorations = is_linux and "NONE" or "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.use_resize_increments = true
config.window_background_opacity = 1
config.native_macos_fullscreen_mode = true
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 5,
}
config.use_ime = false
config.enable_wayland = false
config.enable_csi_u_key_encoding = true
config.bidi_enabled = true

local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return "Dark"
end

local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

local brighteness = get_appearance()
config.color_scheme = scheme_for_appearance(brighteness)

if is_macos then
  config.ssh_domains = {
    {
      name = "workstation",
      remote_address = "workstation",
      assume_shell = "Posix",
      local_echo_threshold_ms = 80,
    },
  }
end

config.unix_domains = {
  {
    name = "unix",
  },
}

config.default_gui_startup_args = { "connect", "unix" }

return config

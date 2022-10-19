local wezterm = require 'wezterm'
local M = {}

M.font = wezterm.font_with_fallback({
  'JetBrainsMono Nerd Font Mono',
})
M.font_size = 16
M.default_cursor_style = "BlinkingUnderline"
M.audible_bell = "Disabled"
M.enable_tab_bar = true
M.use_fancy_tab_bar = false
M.hide_tab_bar_if_only_one_tab = true
M.tab_max_width = 32
M.window_decorations = "RESIZE"
M.window_close_confirmation = "NeverPrompt"
M.use_resize_increments = true
M.window_background_opacity = 0.9
M.initial_rows = 50
M.initial_cols = 180
M.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0
}
M.use_ime = false
M.enable_csi_u_key_encoding = true

local function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

M.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

M.ssh_domains = {
  {
    name = "workstation",
    remote_address = "workstation",
    local_echo_threshold_ms = 80,
  },
}
return M;

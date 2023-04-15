local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font Mono",
})
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
config.window_background_opacity = 0.9
config.initial_rows = 42
config.initial_cols = 148
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.use_ime = false
config.enable_wayland = true
config.enable_csi_u_key_encoding = true

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin configocha"
	else
		return "Catppuccin Latte"
	end
end

local brighteness = "Light"
config.color_scheme = scheme_for_appearance(brighteness)

config.ssh_domains = {
	{
		name = "workstation",
		remote_address = "workstation",
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

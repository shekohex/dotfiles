-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

opt.hlsearch = false
opt.conceallevel = 0
opt.cursorline = false
opt.relativenumber = false
opt.scrolloff = 10
opt.termbidi = true
opt.laststatus = 0

-- Neovide and other GUI Settings
if vim.g.neovide then
  local sysname = vim.loop.os_uname().sysname
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_trail_length = 0.05
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_cursor_vfx_mode = "ripple"
  vim.g.neovide_theme = "auto"
  vim.g.neovide_window_blurred = true
  vim.g.neovide_opacity = 0.70
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_input_use_logo = true
  vim.g.neovide_fullscreen = false
  vim.g.neovide_input_ime = false
  vim.g.neovide_padding_top = 8
  vim.g.neovide_padding_bottom = 8
  vim.g.neovide_padding_right = 8
  vim.g.neovide_padding_left = 8
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_refresh_rate = 120
  if sysname == "Darwin" then
    vim.opt.guifont = "Maple Mono NF:h18"
  elseif sysname == "Linux" then
    vim.opt.guifont = "Maple Mono NF:h16"
    vim.g.neovide_no_idle = true
  else
    vim.opt.guifont = "Maple Mono NF:h18"
  end
end

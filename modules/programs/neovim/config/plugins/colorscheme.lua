local function config_colorscheme()
  local ok, catppuccin = pcall(require, "catppuccin")
  if not ok then
    return
  end

  catppuccin.setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = {
      light = "latte",
      dark = "mocha",
    },
    transparent_background = false,
    show_end_of_buffer = false, -- show the '~' characters after the end of buffers
  })

  -- setup must be called before loading
  vim.cmd.colorscheme("catppuccin")
end

config_colorscheme()

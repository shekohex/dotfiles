local function config_colorscheme()
  local ok, catppuccin = pcall(require, "catppuccin")
  if not ok then
    return
  end

  local os_is_dark = function()
    local output = vim.fn.system(
      "echo $(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo 'dark' || echo 'light')"
    )
    return output:find("dark") ~= nil
  end
  catppuccin.setup({
    flavour = os_is_dark() and "mocha" or "latte",
    background = {
      light = "latte",
      dark = "mocha",
    },
    transparent_background = false,
    show_end_of_buffer = false, -- show the '~' characters after the end of buffers
  })

  local set_os_theme = function()
    if os_is_dark() then
      vim.o.background = "dark"
    else
      vim.o.background = "light"
    end
  end

  set_os_theme()

  -- Register a command to toggle the theme
  vim.api.nvim_create_user_command("ToggleTheme", function()
    if vim.o.background == "dark" then
      vim.o.background = "light"
    else
      vim.o.background = "dark"
    end
  end, { desc = "Toggle Neovim Theme", nargs = "*" })

  -- Register a command to toggle the theme
  vim.api.nvim_create_user_command("SyncTheme", function()
    set_os_theme()
  end, { desc = "Sync Neovim Theme with OS", nargs = "*" })

  -- setup must be called before loading
  vim.cmd.colorscheme("catppuccin")
end

config_colorscheme()

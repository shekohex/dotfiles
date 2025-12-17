local function os_is_dark()
  local sysname = vim.loop.os_uname().sysname
  local output = ""
  if sysname == "Darwin" then
    output = vim.fn.system(
      "echo $(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo 'dark' || echo 'light')"
    )
  elseif sysname == "Linux" then
    output = vim.fn.system(
      "echo $(gsettings get org.gnome.desktop.interface color-scheme | grep -q 'dark' && echo 'dark' || echo 'light')"
    )
  else
    output = "dark"
  end
  return output:find("dark") ~= nil
end

local function set_os_theme()
  vim.o.background = os_is_dark() and "dark" or "light"
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "auto",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      show_end_of_buffer = false,
    },
    init = function()
      set_os_theme()

      vim.api.nvim_create_user_command("ToggleTheme", function()
        vim.o.background = vim.o.background == "dark" and "light" or "dark"
      end, { desc = "Toggle Neovim Theme" })

      vim.api.nvim_create_user_command("SyncTheme", function()
        set_os_theme()
      end, { desc = "Sync Neovim Theme with OS" })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}

local function config_copilot()
  local ok, copilot = pcall(require, "copilot")
  if not ok then
    return
  end

  copilot.setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      yaml = true,
    },
  })

  require("copilot_cmp").setup()
end

config_copilot()

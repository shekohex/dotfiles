local function config_copilot()
  local ok, copilot = pcall(require, "copilot")
  if not ok then
    return
  end

  copilot.setup({
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<M-right>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<M-,>",
      },
    },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      yaml = true,
      toml = true,
    },
  })

  require("copilot_cmp").setup()
end

config_copilot()

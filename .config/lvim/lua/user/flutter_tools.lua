local M = {}

M.config = function()
  local status_ok, flt = pcall(require, "flutter-tools")
  if not status_ok then
    return
  end
  flt.setup {
    ui = { border = "rounded" },
    debugger = { enabled = true, run_via_dap = true },
    outline = { auto_open = false },
    decorations = {
      statusline = { device = true, app_version = true },
    },
    widget_guides = { enabled = true, debug = true },
    dev_log = { open_cmd = "tabedit" },
    lsp = {
      color = {
        background = true,
        virtual_text = false,
      },
      settings = {
        showTodos = false,
        renameFilesWithClasses = "always",
      },
      on_attach = require("lvim.lsp").common_on_attach,
    },
  }
end

return M

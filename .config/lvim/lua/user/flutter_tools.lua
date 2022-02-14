local M = {}

M.config = function()
  local status_ok, flt = pcall(require, "flutter-tools")
  if not status_ok then
    return
  end
  if status_ok then
    require("telescope").load_extension "flutter"
  end
  flt.setup {
    ui = { border = "rounded" },
    debugger = {
      enabled = true,
      run_via_dap = true,
    },
    outline = { auto_open = false },
    decorations = {
      statusline = { device = true, app_version = true },
    },
    fvm = true,
    widget_guides = { enabled = true, debug = true },
    dev_log = { open_cmd = "tabedit", enabled = true },
    dev_tools = {
      autostart = true, -- autostart devtools server if not detected
      auto_open_browser = true, -- Automatically opens devtools in the browser
    },
    lsp = {
      color = {
        enabled = true,
        background = true,
        virtual_text = true,
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

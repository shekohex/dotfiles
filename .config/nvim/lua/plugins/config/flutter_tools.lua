local M = {}

M.setup = function()
  local my_lspconfig = require 'plugins.config.lspconfig'
  require('flutter-tools').setup {
    ui = { border = 'rounded', notification_style = 'native' },
    debugger = { enabled = false },
    fvm = true,
    dev_log = { enabled = true, open_cmd = '10split' },
    lsp = {
      color = {
        enabled = true,
        background = true,
        virtual_text = true,
        virtual_text_str = '■',
      },
      settings = {
        showTodos = false,
        renameFilesWithClasses = 'always',
        enableSnippets = true,
      },
      on_attach = my_lspconfig.on_attach,
      capabilities = my_lspconfig.capabilities(),
    },
  }

  require('telescope').load_extension 'flutter'
end

return M

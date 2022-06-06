local M = {}
M.setup = function()
  require('trouble').setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }

  M.setup_trouble_which_key()
end

M.setup_trouble_which_key = function()
  local wk = require 'which-key'
  wk.register {
    ['<leader>'] = {
      x = {
        name = '+trouble',
        x = {
          '<cmd>Trouble<cr>',
          'All Workspace Issues',
        },
        w = {
          '<cmd>Trouble workspace_diagnostics<cr>',
          'Workspace Diagnostics',
        },
        d = {
          '<cmd>Trouble document_diagnostics<cr>',
          'Diagnostics for Current Document',
        },
      },
    },
  }
end
return M

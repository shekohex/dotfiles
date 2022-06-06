local M = {}

M.recent_projects = function()
  require('telescope').extensions.zoxide.list {}
end

M.setup = function()
  local wk = require 'which-key'
  wk.register {
    ['<leader>'] = {
      f = {
        z = {
          M.recent_projects,
          'Zoxide',
        },
      },
    },
  }
end

return M

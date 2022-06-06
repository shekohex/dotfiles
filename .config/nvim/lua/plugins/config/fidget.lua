local M = {}

M.setup = function()
  require('fidget').setup {
    text = {
      spinner = 'circle_halves',
    },
  }
end

return M

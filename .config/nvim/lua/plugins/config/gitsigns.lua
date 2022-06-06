local M = {}
M.setup = function()
  require('gitsigns').setup {
    current_line_blame = true,
    current_line_blame_formatter = '<author>, <author_time:%R>, <summary>',
  }
end
return M

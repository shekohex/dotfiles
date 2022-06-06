local M = {}

M.setup = function()
  -- Indent blankline
  require('indent_blankline').setup {
    char = '┊',
    show_trailing_blankline_indent = true,
  }
end

return M

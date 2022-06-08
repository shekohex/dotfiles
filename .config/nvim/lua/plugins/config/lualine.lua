local M = {}

M.setup = function()
  if not pcall(require, 'lualine') then
    return
  end
  --Set statusbar
  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = '|',
      section_separators = { left = '', right = '' },
    },
    sections = {
      lualine_a = {
        { 'mode', separator = { left = '' }, right_padding = 0 },
      },
      lualine_b = {
        { 'filename', file_status = false, path = 1 },
        'branch',
        { 'diff', source = M.diff_source },
      },
      lualine_c = { 'fileformat' },
      lualine_x = {
        {
          'diagnostics',
          sources = { 'nvim_diagnostic' },
          symbols = { error = ' ', warn = ' ', info = ' ' },
        },
      },
      lualine_y = { 'filetype', 'progress' },
      lualine_z = {
        { 'location', separator = { right = '' }, left_padding = 0 },
      },
    },
    inactive_sections = {
      lualine_a = { 'filename' },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { 'location' },
    },
    extensions = {},
  }
end

M.diff_source = function()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

return M

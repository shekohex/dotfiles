local M = {}

M.gruvbox = function()
  vim.g.gruvbox_contrast_dark = "soft" -- Changes dark mode contrasts. Possible values are soft, medium, and hard. Default is medium
  vim.g.gruvbox_italicize_comments = true -- Enables italics for comments
  vim.g.gruvbox_italicize_strings = false -- Enables italics for strings
  vim.g.gruvbox_improved_strings = false -- Enables improved string highlighting
end

return M

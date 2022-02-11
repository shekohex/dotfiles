local M = {}

M.gruvbox = function()
  vim.g.gruvbox_contrast_dark = "soft" -- Changes dark mode contrasts. Possible values are soft, medium, and hard. Default is medium
  vim.g.gruvbox_italicize_comments = true -- Enables italics for comments
  vim.g.gruvbox_italicize_strings = true -- Enables italics for strings
end

return M

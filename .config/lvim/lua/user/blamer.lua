local M = {}
M.config = function()
  vim.g.blamer_enabled = true
  vim.g.blamer_delay = 600 -- milliseconds
  vim.g.blamer_template = "<author>, <committer-time> • <summary>"
  vim.g.blamer_relative_time = true
end
return M

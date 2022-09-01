local M = {}

M.setup = function()
  -- Enable the following language servers
  local servers = { 'tsserver' }
  require('mason-lspconfig').setup {
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ensure_installed = servers,
  }
end

return M

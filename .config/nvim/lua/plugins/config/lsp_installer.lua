local M = {}

M.setup = function()
  local lspconfig = require 'lspconfig'
  local my_lspconfig = require 'plugins.config.lspconfig'
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  -- Enable the following language servers
  local servers = { 'tsserver' }
  require('nvim-lsp-installer').setup {
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ensure_installed = servers,
  }
  local lsp_installer_servers = require 'nvim-lsp-installer.servers'
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = my_lspconfig.on_attach,
      capabilities = capabilities,
    }
  end
end

return M

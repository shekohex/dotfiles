local M = {}

M.setup = function()
  local null_ls_status_ok, null_ls = pcall(require, 'null-ls')
  if not null_ls_status_ok then
    return
  end
  local my_lspconfig = require 'plugins.config.lspconfig'
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local code_actions = null_ls.builtins.code_actions
  local completion = null_ls.builtins.completion
  null_ls.setup {
    debug = false,
    sources = {
      code_actions.gitsigns,
      formatting.prettier,
      formatting.stylua,
      formatting.codespell,
      diagnostics.luacheck,
      diagnostics.actionlint,
      diagnostics.codespell,
      diagnostics.zsh,
      completion.spell,
    },
    on_attach = my_lspconfig.on_attach,
  }
end

return M

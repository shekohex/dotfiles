local lspconfig = require("lspconfig")
vim.g.typescript_enabled = false

if vim.g.typescript_enabled then
  local typescript_loaded, typescript = pcall(require, "typescript")
  if not typescript_loaded then
    return
  end
  typescript.setup({
    server = {
      root_dir = lspconfig.util.root_pattern("package.json"),
    },
  })
end

-- Deno LSP
lspconfig.denols.setup({
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
  init_options = {
    lint = true,
  },
})

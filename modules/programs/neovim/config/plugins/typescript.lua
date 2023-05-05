local lspconfig = require("lspconfig")
local typescript_loaded, typescript = pcall(require, "typescript")
if typescript_loaded then
  typescript.setup({
    server = {
      root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json"),
    },
  })
end

-- Deno LSP
lspconfig.denols.setup({
  root_dir = lspconfig.util.root_pattern("deno.json"),
  init_options = {
    lint = true,
  },
})

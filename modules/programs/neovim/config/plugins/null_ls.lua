local null_ls = require("null-ls")

local function typescript_code_actions()
  local status_ok, _ = pcall(require, "typescript")
  if not status_ok then
    return
  end
  return require("typescript.extensions.null-ls.code-actions")
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
  -- you can reuse a shared lspconfig on_attach callback here
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.deno_fmt.with({
      filetypes = { "javascript", "javascriptreact", "json", "jsonc", "typescript", "typescriptreact" },
    }),
    typescript_code_actions(),
  },
})

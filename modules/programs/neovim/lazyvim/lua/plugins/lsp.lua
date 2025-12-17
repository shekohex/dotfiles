return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        keys = {
          { "K", vim.lsp.buf.hover, desc = "Hover" },
          { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
          { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Definitions" },
          { "gT", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Type Definitions" },
          { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
          { "gD", vim.lsp.buf.declaration, desc = "Declaration" },
          { "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
          { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
          { "<F2>", vim.lsp.buf.rename, desc = "Rename" },
          { "<leader>cf", vim.lsp.buf.format, mode = { "n", "x" }, desc = "Format", has = "documentFormatting" },
          { "<leader>ca", vim.lsp.buf.code_action, mode = { "n", "v" }, desc = "Code Action", has = "codeAction" },
          { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
          { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
          { "gl", vim.diagnostic.open_float, desc = "Line Diagnostics" },
          { "[d", vim.diagnostic.goto_prev, desc = "Prev Diagnostic" },
          { "]d", vim.diagnostic.goto_next, desc = "Next Diagnostic" },
        },
      },
    },
  },
}

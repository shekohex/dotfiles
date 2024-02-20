vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {},
  -- LSP configuration
  server = {
    default_settings = {
      -- rust-analyzer language server configuration
      ["rust-analyzer"] = {
        lens = {
          enable = true,
        },
        checkOnSave = {
          command = "clippy",
          extraArgs = { "--tests" },
        },
        inlayHints = { locationLinks = false },
        procMacro = {
          enable = true,
        },
        files = {
          excludeDirs = { "tests/node_modules", "node_modules", ".direnv" },
        },
      },
    },
  },
  -- DAP configuration
  dap = {},
}

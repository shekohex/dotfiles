vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {},
  -- LSP configuration
  server = {
    default_settings = {
      -- rust-analyzer language server configuration
      ["rust-analyzer"] = {
        diagnostics = { disabled = { "unresolved-proc-macro", "remove-unnecessary-else" } },
        lens = { enable = true },
        checkOnSave = true,
        check = {
          command = "clippy",
          extraArgs = { "--tests" },
          extraEnv = {
            -- Skip WASM Build on substrate projects
            SKIP_WASM_BUILD = 1,
          },
        },
        cargo = {
          buildScripts = { enable = true },
          extraEnv = {
            -- Skip WASM Build on substrate projects
            SKIP_WASM_BUILD = 1,
          },
        },
        inlayHints = { locationLinks = false },
        procMacro = {
          enable = true,
          ignored = {
            async_trait = { "async_trait" },
          },
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

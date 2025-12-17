return {
  "mrcjkb/rustaceanvim",
  opts = {
    server = {
      default_settings = {
        ["rust-analyzer"] = {
          diagnostics = { disabled = { "unresolved-proc-macro", "remove-unnecessary-else" } },
          lens = { enable = true },
          checkOnSave = true,
          check = {
            buildScripts = { enable = true },
            command = "clippy",
            features = "all",
            extraArgs = { "--tests" },
            extraEnv = {
              SKIP_WASM_BUILD = 1,
            },
          },
          cargo = {
            buildScripts = { enable = true },
            features = "all",
            noDefaultFeatures = false,
            extraEnv = {
              SKIP_WASM_BUILD = 1,
            },
          },
          inlayHints = { locationLinks = false },
          procMacro = {
            enable = true,
            ignored = {
              async_trait = { "async_trait" },
              leptos_macro = { "server" },
            },
          },
          files = {
            excludeDirs = { "tests/node_modules", "node_modules", ".direnv", ".embuild" },
          },
          rustfmt = vim.fn.executable("leptosfmt") == 1
              and { overrideCommand = { "leptosfmt", "--stdin", "--rustfmt" } }
            or {},
        },
      },
    },
  },
}

-- Treesitter configuration
require("nvim-treesitter.configs").setup({
  -- we installed everything using nix
  ensure_installed = {},
  auto_install = false,
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  sync_install = true,
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn", -- set to `false` to disable one of the mappings
      node_incremental = "gnn",
      scope_incremental = "grc",
      node_decremental = "grp",
    },
  },
  indent = {
    enable = true, -- a bit buggy right now
  },
  rainbow = {
    enable = true,
  },
  modules = {},
  ignore_install = {},
})

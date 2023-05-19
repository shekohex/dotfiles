-- Treesitter configuration
require("nvim-treesitter.configs").setup({
  -- we installed everything using nix
  ensure_installed = {},
  auto_install = false,
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn", -- set to `false` to disable one of the mappings
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true, -- a bit buggy right now
  },
  rainbow = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
})

-- Setup Folding using Treesitter
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- Disable Folding by default
vim.opt.foldenable = false
-- A workaround this issue:
-- https://github.com/nvim-telescope/telescope.nvim/issues/699
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*" },
  command = "normal zx zR",
})

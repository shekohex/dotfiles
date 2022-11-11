local M = {}
M.plugins = {
  ['wbthomason/packer.nvim'] = {},
  ['lewis6991/impatient.nvim'] = {},
  ['nvim-lualine/lualine.nvim'] = {
    disable = false,
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('plugins.config.lualine').setup()
    end,
  },
  ['nvim-treesitter/nvim-treesitter'] = {
    disable = false,
    run = ':TSUpdate',
    config = function()
      require('plugins.config.treesitter').setup()
    end,
  },
  ['sheerun/vim-polyglot'] = {
    disable = false,
    config = function()
      require('plugins.config.polygot').setup()
    end,
  },
  ['nvim-treesitter/nvim-treesitter-textobjects'] = {
    disable = false,
    requires = { 'nvim-treesitter/nvim-treesitter' },
  },
}

M.setup = function()
  require('core.packer').run(M.plugins)
end

return M

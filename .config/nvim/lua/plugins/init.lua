local M = {}

M.plugins = {
  ['wbthomason/packer.nvim'] = {},
  ['lewis6991/impatient.nvim'] = {},
  ['numToStr/Comment.nvim'] = {
    disable = false,
    module = 'Comment',
    config = function()
      require('plugins.config.comment').setup()
    end,
  },
  ['gelguy/wilder.nvim'] = {
    disable = false,
    config = function()
      require('plugins.config.wilder').setup()
    end,
  },
  ['karb94/neoscroll.nvim'] = {
    disable = false,
    config = function()
      require('plugins.config.neoscroll').setup()
    end,
  },
  ['lewis6991/gitsigns.nvim'] = {
    disable = false,
    config = function()
      require('plugins.config.gitsigns').setup()
    end,
  },
  ['phaazon/hop.nvim'] = {
    disable = false,
    branch = 'v1.3',
    config = function()
      require('plugins.config.hop').setup()
    end,
  },
  ['nvim-lua/plenary.nvim'] = {
    disable = false,
  },
  ['nvim-telescope/telescope.nvim'] = {
    disable = false,
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('plugins.config.telescope').setup()
    end,
  },
  ['nvim-telescope/telescope-ui-select.nvim'] = {
    disable = false,
    config = function()
      require('plugins.config.telescope').setup_ui_select()
    end,
  },
  ['nvim-telescope/telescope-fzf-native.nvim'] = {
    disable = false,
    run = 'make',
  },
  ['romgrk/fzy-lua-native'] = {
    disable = false,
    run = 'make',
  },
  ['junegunn/fzf'] = {
    disable = false,
    run = function()
      vim.fn['fzf#install']()
    end,
  },
  ['jvgrootveld/telescope-zoxide'] = {
    disable = false,
    config = function()
      require('plugins.config.zoxide').setup()
    end,
  },
  ['ellisonleao/gruvbox.nvim'] = {
    config = function()
      require('plugins.config.gruvbox').setup()
    end,
  },
  ['kyazdani42/nvim-web-devicons'] = {
    disable = false,
  },
  ['nvim-lualine/lualine.nvim'] = {
    disable = false,
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('plugins.config.lualine').setup()
    end,
  },
  ['lukas-reineke/indent-blankline.nvim'] = {
    disable = false,
    config = function()
      require('plugins.config.indent_blankline').setup()
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
  ['kevinhwang91/nvim-bqf'] = {
    disable = false,
    ft = 'qf',
    requires = { 'nvim-treesitter/nvim-treesitter' },
  },
  ['williamboman/nvim-lsp-installer'] = {
    disable = false,
    config = function()
      require('plugins.config.lsp_installer').setup()
    end,
  },
  ['neovim/nvim-lspconfig'] = {
    disable = false,
    config = function()
      require('plugins.config.lspconfig').setup()
    end,
  },
  ['onsails/lspkind.nvim'] = {
    disable = false,
  },
  ['hrsh7th/nvim-cmp'] = {
    disable = false,
    config = function()
      require('plugins.config.cmp').setup()
    end,
  },
  ['hrsh7th/cmp-nvim-lsp'] = {
    disable = false,
  },
  ['L3MON4D3/LuaSnip'] = {
    disable = false,
    config = function()
      require('plugins.config.luasnip').setup()
    end,
  },
  ['saadparwaiz1/cmp_luasnip'] = {
    disable = false,
  },
  ['hrsh7th/cmp-buffer'] = {
    disable = false,
  },

  ['hrsh7th/cmp-path'] = {
    disable = false,
  },
  ['ray-x/lsp_signature.nvim'] = {
    disable = true,
    config = function()
      require('plugins.config.lspsignature').setup()
    end,
  },
  ['j-hui/fidget.nvim'] = {
    disable = false,
    config = function()
      require('plugins.config.fidget').setup()
    end,
  },
  ['folke/lsp-colors.nvim'] = {
    disable = false,
    config = function()
      require('plugins.config.lspcolors').setup()
    end,
  },
  ['norcalli/nvim-colorizer.lua'] = {
    disable = false,
    config = function()
      require('plugins.config.colorizer').setup()
    end,
  },
  ['simrat39/rust-tools.nvim'] = {
    disable = false,
    config = function()
      require('plugins.config.rust_tools').setup()
    end,
  },
  ['dart-lang/dart-vim-plugin'] = {
    disable = false,
  },
  ['akinsho/flutter-tools.nvim'] = {
    disable = false,
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('plugins.config.flutter_tools').setup()
    end,
  },
  ['folke/trouble.nvim'] = {
    disable = false,
    config = function()
      require('plugins.config.trouble').setup()
    end,
  },
  ['wakatime/vim-wakatime'] = {},
  ['github/copilot.vim'] = {
    disable = false,
    config = function()
      require('plugins.config.copilot').setup()
    end,
  },
  ['rmagatti/session-lens'] = {
    disable = false,
    requires = { 'rmagatti/auto-session', 'nvim-telescope/telescope.nvim' },
    config = function()
      require('plugins.config.auto_session').setup()
    end,
  },
  ['folke/which-key.nvim'] = {
    disable = false,
    config = function()
      require('plugins.config.whichkey').setup()
    end,
  },
  ['jghauser/mkdir.nvim'] = {
    disable = false,
  },
  ['andweeb/presence.nvim'] = {
    disable = false,
    config = function()
      require('plugins.config.presence').setup()
    end,
  }
}

M.setup = function()
  require('core.packer').run(M.plugins)
end

return M

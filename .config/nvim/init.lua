-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]]

local use = require('packer').use
require('packer').startup(function()
    use 'wbthomason/packer.nvim' -- Package manager
    use 'tpope/vim-fugitive' -- Git commands in nvim
    use 'tpope/vim-commentary' -- "gc" to comment visual regions/lines
    -- UI to select things (files, grep results, open buffers...)
    use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    use { 'nvim-telescope/telescope-ui-select.nvim' }
    use { 'ellisonleao/gruvbox.nvim', requires = { 'rktjmp/lush.nvim' } }
    use 'beauwilliams/statusline.lua' -- Fancier statusline
    -- Add indentation guides even on blank lines
    use 'lukas-reineke/indent-blankline.nvim'
    -- Add git related info in the signs columns and popups
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    -- Highlight, edit, and navigate code using a fast incremental parsing library
    use 'nvim-treesitter/nvim-treesitter'
    -- Additional textobjects for treesitter
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    -- LSP & LSP Helpers
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    use 'nvim-lua/lsp-status.nvim'
    use 'kosayoda/nvim-lightbulb'
    use 'neovim/nvim-lspconfig'

    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'dcampos/nvim-snippy'
    use 'dcampos/cmp-snippy'

    -- Custom Language tools
    use 'simrat39/rust-tools.nvim'
    -- Utils
    use 'nvim-lua/plenary.nvim'
end)

-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local cmd = vim.cmd             -- execute Vim commands
local exec = vim.api.nvim_exec  -- execute Vimscript
local g = vim.g                 -- global variables
local opt = vim.opt             -- global/buffer/windows-scoped options

-----------------------------------------------------------
-- General
-----------------------------------------------------------
g.mapleader = ','             -- change leader to a comma
opt.mouse = 'a'               -- enable mouse support
opt.clipboard = 'unnamedplus' -- copy/paste to system clipboard
opt.swapfile = false          -- don't use swapfile

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true             -- show line number
opt.showmatch = true          -- highlight matching parenthesis
opt.foldmethod = 'marker'     -- enable folding (default 'foldmarker')
opt.colorcolumn = '100'       -- line lenght marker at 100 columns
opt.splitright = true         -- vertical split to the right
opt.splitbelow = true         -- orizontal split to the bottom
opt.ignorecase = true         -- ignore case letters when search
opt.smartcase = true          -- ignore lowercase for the whole pattern
opt.linebreak = true          -- wrap on word boundary

-- remove whitespace on save
cmd [[au BufWritePre * :%s/\s\+$//e]]


-- highlight on yank
exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
  augroup end
]], false)

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true         -- enable background buffers
opt.history = 100         -- remember n lines in history
opt.lazyredraw = true     -- faster scrolling
opt.synmaxcol = 240       -- max column for syntax highlight

-----------------------------------------------------------
-- Colorscheme
-----------------------------------------------------------
opt.termguicolors = true      -- enable 24-bit RGB colors
opt.background = "dark"       -- or "light" for light mode
cmd [[colorscheme gruvbox]]


-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true      -- use spaces instead of tabs
opt.shiftwidth = 4        -- shift 4 spaces when tab
opt.tabstop = 4           -- 1 tab == 4 spaces
opt.smartindent = true    -- autoindent new lines

-----------------------------------------------------------
-- Autocompletion
-----------------------------------------------------------
-- insert mode completion options
opt.completeopt = 'menuone,noselect'

-----------------------------------------------------------
-- Terminal
-----------------------------------------------------------
-- open a terminal pane on the right using :Term
cmd [[command Term :botright vsplit term://$SHELL]]

-- Terminal visual tweaks
--- enter insert mode when switching to terminal
--- close terminal buffer on process exit
cmd [[
    autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
    autocmd TermOpen * startinsert
    autocmd BufLeave term://* stopinsert
]]

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- disable builtins plugins
local disabled_built_ins = {
    "netrw",
    "netrwusein",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipusein",
    "tar",
    "tarusein",
    "getscript",
    "getscriptusein",
    "vimball",
    "vimballusein",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end

-- disable nvim intro
opt.shortmess:append "sI"
--Set highlight on search
opt.hlsearch = false
--Save undo history
opt.undofile = true

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

--Map blankline
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { hl = 'GitGutterAdd', text = '+' },
    change = { hl = 'GitGutterChange', text = '~' },
    delete = { hl = 'GitGutterDelete', text = '_' },
    topdelete = { hl = 'GitGutterDelete', text = '‾' },
    changedelete = { hl = 'GitGutterChange', text = '~' },
  },
}

-- Telescope
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }
    }
  }
}

--Add leader shortcuts
vim.api.nvim_set_keymap(
    'n',
    '<C-p>',
    [[<cmd>lua require('telescope.builtin').live_grep()<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n',
    '<leader>sf',
    [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>sb',
    [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n',
    '<leader>sh',
    [[<cmd>lua require('telescope.builtin').help_tags()<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n',
    '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'n', '<leader>sd',
    [[<cmd>lua require('telescope.builtin').grep_string()<CR>]],
    { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
    'n',
    '<leader>?',
    [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]],
    { noremap = true, silent = true }
)

--LSP Configs
local nvim_lsp = require('lspconfig')
local lsp_servers_path = table.concat({ vim.fn.stdpath "data", "lsp_servers" }, "/")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
--LSP Status, for statusline
local lsp_status = require('lsp-status')
lsp_status.register_progress()
--Lightbulb
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

-- Setup Completion
local cmp = require('cmp')
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        require('snippy').expand_snippet(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'snippy' },
    { name = 'path' },
    { name = 'buffer' },
  },
})

-- Add completion shortcuts
vim.api.nvim_set_keymap('n', 'K', [[<cmd>lua vim.lsp.buf.hover()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gi', [[<cmd>lua vim.lsp.buf.implementation()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gd', [[<cmd>lua vim.lsp.buf.definition()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', [[<cmd>lua vim.lsp.buf.references()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'g[', [[<cmd>lua vim.diagnostic.goto_prev()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'g]', [[<cmd>lua vim.diagnostic.goto_next()<CR>]], { noremap = true, silent = true })
-- Show diagnostic popup on cursor hold
cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })]]
--Json LSP
nvim_lsp.jsonls.setup { capabilities = capabilities }
--Toml LSP
nvim_lsp.taplo.setup { }
--Lua LSP
nvim_lsp.sumneko_lua.setup {
	on_attach = lsp_status.on_attach,
	capabilities = lsp_status.capabilities,
	settings = {
		Lua = {
			diagnostics = {
        		-- Get the language server to recognize the `vim` global
        		globals = {'vim'},
			},
      		workspace = {
        		-- Make the server aware of Neovim runtime files
        		library = vim.api.nvim_get_runtime_file("", true),
      		},
      		-- Do not send telemetry data containing a randomized but unique identifier
      		telemetry = {
        		enable = false,
      		},
    	},
	},
	flags = {
		debounce_text_change = 50,
	}
}

-- Rust
-- Configure LSP through rust-tools.nvim plugin.
-- rust-tools will configure and enable certain LSP features for us.
-- See https://github.com/simrat39/rust-tools.nvim#configuration
local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        cmd = { table.concat({ lsp_servers_path, "rust", "rust-analyzer" }, "/") },
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(opts)

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
}


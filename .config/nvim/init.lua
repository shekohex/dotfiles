-- Install packer
local install_path = vim.fn.stdpath 'data'
    .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.execute(
        '!git clone https://github.com/wbthomason/packer.nvim ' .. install_path
    )
end

local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    command = 'source <afile> | PackerCompile',
    group = packer_group,
    pattern = 'init.lua',
})

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim' -- Package manager
    use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
    use 'lewis6991/gitsigns.nvim'
    -- UI to select things (files, grep results, open buffers...)
    use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    use { 'nvim-telescope/telescope-ui-select.nvim' }
    -- Theme
    use { 'ellisonleao/gruvbox.nvim' }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    }
    -- Add indentation guides even on blank lines
    use 'lukas-reineke/indent-blankline.nvim'
    -- Highlight, edit, and navigate code using a fast incremental parsing library
    use 'nvim-treesitter/nvim-treesitter'
    use 'sheerun/vim-polyglot'
    -- Additional textobjects for treesitter
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'williamboman/nvim-lsp-installer' -- For installing LSP servers
    use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
    use 'nvim-lua/lsp-status.nvim' -- To Show LSP Status in status line
    use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip' -- Snippets plugin
    -- Rust
    use 'simrat39/rust-tools.nvim'
    -- Flutter and Dart
    use { 'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim' }
    -- Misc
    use 'wakatime/vim-wakatime'
    use { 'github/copilot.vim', config = function()
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true
        vim.g.copilot_tab_fallback = ""
        vim.g.copilot_filetypes = {
            ["*"] = false,
            python = true,
            lua = true,
            go = true,
            rust = true,
            html = true,
            c = true,
            cpp = true,
            java = true,
            javascript = true,
            typescript = true,
            javascriptreact = true,
            typescriptreact = true,
            terraform = true,
            dart = true,
            zsh = true,
            sh = true,
            bash = true,
            toml = true,
            json = true,
            yaml = true,
        }
    end
    }
end)

--Set highlight on search
vim.o.hlsearch = false

-- Noob mode
vim.o.mouse = 'c'

--Make line numbers default
vim.wo.number = true

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

--Set colorscheme
vim.o.termguicolors = true
vim.o.background = 'light'
vim.cmd 'colorscheme gruvbox'

local disabled_plugins = {
    '2html_plugin',
    'getscript',
    'getscriptPlugin',
    'gzip',
    'logipat',
    'netrw',
    'netrwPlugin',
    'netrwSettings',
    'netrwFileHandlers',
    'matchit',
    'tar',
    'tarPlugin',
    'rrhelper',
    'spellfile_plugin',
    'vimball',
    'vimballPlugin',
    'zip',
    'zipPlugin',
}
for _, plugin in pairs(disabled_plugins) do
    vim.g['loaded_' .. plugin] = 1
end
vim.g.ultest_summary_width = 30
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.termguicolors = true
vim.opt.updatetime = 100
vim.opt.redrawtime = 1500
vim.opt.ttimeoutlen = 10
vim.opt.wrapscan = true -- Searches wrap around the end of the file
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldlevel = 4
vim.wo.foldnestmax = 3
vim.wo.foldminlines = 1
vim.opt.cmdheight = 1
vim.g.dashboard_enable_session = 0
vim.g.dashboard_disable_statusline = 1
vim.opt.pumblend = 10
vim.opt.mouse = 'c' -- disable mouse
vim.opt.joinspaces = false
vim.opt.background = 'light'
vim.opt.list = true
vim.opt.confirm = true -- make vim prompt me to save before doing destructive things
vim.opt.autowriteall = true -- automatically :write before running commands and changing files
vim.opt.clipboard = 'unnamedplus'
vim.opt.fillchars = {
    vert = '▕', -- alternatives │
    fold = ' ',
    eob = ' ', -- suppress ~ at EndOfBuffer
    diff = '╱', -- alternatives = ⣿ ░ ─
    msgsep = '‾',
    foldopen = '▾',
    foldsep = '│',
    foldclose = '▸',
}
vim.opt.wildignore = {
    '*.aux,*.out,*.toc',
    '*.o,*.obj,*.dll,*.jar,*.pyc,__pycache__,*.rbc,*.class',
    -- media
    '*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp',
    '*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm',
    '*.eot,*.otf,*.ttf,*.woff',
    '*.doc,*.pdf',
    -- archives
    '*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz',
    -- temp/system
    '*.*~,*~ ',
    '*.swp,.lock,.DS_Store,._*,tags.lock',
    -- version control
    '.git,.svn',
}
vim.opt.shortmess = {
    t = true, -- truncate file messages at start
    A = true, -- ignore annoying swap file messages
    o = true, -- file-read message overwrites previous
    O = true, -- file-read message overwrites previous
    T = true, -- truncate non-file messages in middle
    f = true, -- (file x of x) instead of just (x of x
    F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
    s = true,
    c = true,
    W = true, -- Don't show [w] or written when writing
}
vim.opt.formatoptions = {
    ['1'] = true,
    ['2'] = true, -- Use indent from 2nd line of a paragraph
    q = true, -- continue comments with gq"
    c = true, -- Auto-wrap comments using textwidth
    r = true, -- Continue comments when pressing Enter
    n = true, -- Recognize numbered lists
    t = false, -- autowrap lines using text width value
    j = true, -- remove a comment leader when joining lines.
    -- Only break if the line was not longer than 'textwidth' when the insert
    -- started and only at a white character that has been entered during the
    -- current insert command.
    l = true,
    v = true,
}
vim.opt.listchars = {
    eol = nil,
    tab = '│ ',
    extends = '›', -- Alternatives: … »
    precedes = '‹', -- Alternatives: … «
    trail = '•', -- BULLET (U+2022, UTF-8: E2 80 A2)
}

if vim.g.neovide then
    vim.g.neovide_cursor_animation_length = 0.05
    vim.g.neovide_cursor_trail_length = 0.05
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_remember_window_size = true
    vim.g.neovide_input_use_logo = true
    vim.g.neovide_cursor_vfx_mode = 'ripple'
    vim.opt.guifont = 'Iosevka Nerd Font:h18'
    vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Setup gitsigns
require('gitsigns').setup {
    current_line_blame = true,
    current_line_blame_formatter = '<author>, <author_time:%R>, <summary>',
}

--Set statusbar
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
    },
    sections = {
        lualine_x = {
            'require("lsp-status").status()',
            'encoding',
            'fileformat',
            'filetype',
        },
    }
}

--Enable Comment.nvim
require('Comment').setup {}

--Remap ',' as leader key
vim.keymap.set({ 'n', 'v' }, ',', '<Nop>', { silent = true })
vim.g.mapleader = ','
vim.g.maplocalleader = ','

--Remap for dealing with word wrap
vim.keymap.set(
    'n',
    'k',
    "v:count == 0 ? 'gk' : 'k'",
    { expr = true, silent = true }
)
vim.keymap.set(
    'n',
    'j',
    "v:count == 0 ? 'gj' : 'j'",
    { expr = true, silent = true }
)

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup(
    'YankHighlight',
    { clear = true }
)
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- Indent blankline
require('indent_blankline').setup {
    char = '┊',
    show_trailing_blankline_indent = true,
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
        file_ignore_patterns = {
            "vendor/*",
            "%.lock",
            "__pycache__/*",
            "%.sqlite3",
            "%.ipynb",
            "node_modules/*",
            "%.jpg",
            "%.jpeg",
            "%.png",
            "%.svg",
            "%.otf",
            "%.ttf",
            ".git/",
            "%.webp",
            ".dart_tool/",
            ".github/",
            ".gradle/",
            ".idea/",
            ".settings/",
            ".vscode/",
            "__pycache__/",
            "build/",
            "env/",
            "gradle/",
            "node_modules/",
            "target/",
            "%.pdb",
            "%.dll",
            "%.class",
            "%.exe",
            "%.cache",
            "%.ico",
            "%.pdf",
            "%.dylib",
            "%.jar",
            "%.docx",
            "%.met",
            "smalljre_*/*",
            ".vale/",
            "%.burp",
            "%.mp4",
            "%.mkv",
            "%.rar",
            "%.zip",
            "%.7z",
            "%.tar",
            "%.bz2",
            "%.epub",
            "%.flac",
            "%.tar.gz",
            "packer_compiled.lua",
        }
    },
}

require("telescope").load_extension("ui-select")

--Add leader shortcuts
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>ff', function()
    require('telescope.builtin').find_files { previewer = false }
end)
vim.keymap.set(
    'n',
    '<leader>fb',
    require('telescope.builtin').current_buffer_fuzzy_find
)
vim.keymap.set('n', '<leader>st', require('telescope.builtin').tags)
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').grep_string)
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>so', function()
    require('telescope.builtin').tags { only_current_buffer = true }
end)
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles)

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true, -- false will disable the whole extension
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-n>",
            node_incremental = "<C-n>",
            scope_incremental = "<C-s>",
            node_decremental = "<C-r>",
        },
    },
    indent = {
        enable = false, -- a bit buggy right now
    },
    rainbow = {
        enable = true,
        extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
        max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["ib"] = "@block.inner",
                ["ab"] = "@block.outer",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader><C-a>"] = "@parameter.inner",
                ["<leader><C-f>"] = "@function.outer",
                ["<leader><C-e>"] = "@element",
            },
            swap_previous = {
                ["<leader><C-A>"] = "@parameter.inner",
                ["<leader><C-F>"] = "@function.outer",
                ["<leader><C-E>"] = "@element",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]f"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]F"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[f"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[F"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
    },
}

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Github Copilot keymaps
vim.keymap.set('i', '<c-d>', vim.fn['copilot#Dismiss'], { expr = true, script = true, silent = true })
vim.keymap.set('i', '<c-n>', vim.fn['copilot#Next'], { expr = true, script = true, silent = true })
vim.keymap.set('i', '<c-p>', vim.fn['copilot#Previous'], { expr = true, script = true, silent = true })
vim.keymap.set('i', '<c-h>', vim.fn['copilot#Accept'], { expr = true, script = true, silent = true })

-- LSP settings
local lsp_status = require('lsp-status')
local lspconfig = require('lspconfig')
local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
        vim.inspect(vim.lsp.buf.list_workspace_folders())
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set(
        'n',
        '<leader>so',
        require('telescope.builtin').lsp_document_symbols,
        opts
    )
    vim.api.nvim_create_user_command('Format', vim.lsp.buf.formatting, {})
    local lsp_augroup = 'lsp_augroup' .. bufnr
    vim.api.nvim_create_augroup(lsp_augroup, { clear = true })
    vim.api.nvim_create_autocmd('BufWritePre', {
        group = lsp_augroup,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.formatting_sync(nil, 5000)
        end
    })
    lsp_status.on_attach(client)
end

lsp_status.config({
    show_filename = false,
    current_function = false,
    diagnostics = false,
    status_symbol = '',
    select_symbol = nil,
    update_interval = 500,
})
-- Register the progress handler
lsp_status.register_progress()
-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)
-- Enable the following language servers
local servers = { 'tsserver' }
require('nvim-lsp-installer').setup {
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ensure_installed = servers,
}
local lsp_installer_servers = require("nvim-lsp-installer.servers")
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

-- Rust
local _, rust_analyzer = lsp_installer_servers.get_server("rust_analyzer")

require("rust-tools").setup {
    tools = {
        autoSetHints = true,
        hover_with_actions = true,
        executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
        runnables = {
            use_telescope = true,
            prompt_prefix = "  ",
            selection_caret = "  ",
            entry_prefix = "  ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "descending",
            layout_strategy = "vertical",
            layout_config = {
                width = 0.3,
                height = 0.50,
                preview_cutoff = 0,
                prompt_position = "bottom",
            },
        },
        debuggables = {
            use_telescope = true,
        },
        inlay_hints = {
            only_current_line = false,
            show_parameter_hints = true,
            parameter_hints_prefix = " <- ",
            other_hints_prefix = " => ",
            max_len_align = false,
            max_len_align_padding = 2,
            right_align = false,
            right_align_padding = 7,
            highlight = "Comment",
        },
        hover_actions = {
            border = {
                { "╭", "FloatBorder" },
                { "─", "FloatBorder" },
                { "╮", "FloatBorder" },
                { "│", "FloatBorder" },
                { "╯", "FloatBorder" },
                { "─", "FloatBorder" },
                { "╰", "FloatBorder" },
                { "│", "FloatBorder" },
            },
            auto_focus = true,
        },
    },
    server = {
        cmd_env = rust_analyzer._default_options.cmd_env,
        on_attach = on_attach,
    },
}

-- Flutter Tools

require('flutter-tools').setup {
    ui = { border = "rounded", notification_style = "native" },
    debugger = { enabled = false },
    fvm = true,
    dev_log = { enabled = true, open_cmd = "30vsplit" },
    lsp = {
        color = {
            enabled = true,
            background = true,
            virtual_text = true,
            virtual_text_str = "■",
        },
        settings = {
            showTodos = false,
            renameFilesWithClasses = "always",
            enableSnippets = true,
        },
        on_attach = on_attach,
        capabilities = capabilities,
    },
}

require("telescope").load_extension("flutter")

-- Example custom server
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

lspconfig.sumneko_lua.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file('', true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            local copilot_keys = vim.fn["copilot#Accept"]()
            if cmp.visible() then
                cmp.select_next_item()
            elseif copilot_keys ~= "" then -- prioritise copilot over snippets
                -- Copilot keys do not need to be wrapped in termcodes
                vim.api.nvim_feedkeys(copilot_keys, "i", true)
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "cmp_tabnine", max_item_count = 3 },
        { name = "buffer", max_item_count = 5, keyword_length = 5 },
        { name = "path", max_item_count = 5 },
        { name = "luasnip", max_item_count = 3 },
        { name = "nvim_lua" },
        { name = "calc" },
        { name = "emoji" },
        { name = "treesitter" },
        { name = "crates" },
        { name = "orgmode" },
    },
    formatting = {
        kind_icons = {
            Class = " ",
            Color = " ",
            Constant = "",
            Constructor = " ",
            Default = " ",
            Enum = "練",
            EnumMember = " ",
            Event = " ",
            Field = "ﰠ ",
            File = " ",
            Folder = " ",
            Function = " ",
            Interface = " ",
            Keyword = " ",
            Method = "ƒ ",
            Module = " ",
            Operator = " ",
            Property = " ",
            Reference = "",
            Snippet = " ", -- " "," "
            Struct = "פּ ",
            Text = " ",
            TypeParameter = "  ",
            Unit = "塞",
            Value = " ",
            Variable = " ",
        },
        source_names = {
            buffer = "(Buffer)",
            nvim_lsp = "(LSP)",
            luasnip = "(Snip)",
            treesitter = "",
            nvim_lua = "(NvLua)",
            spell = "暈",
            emoji = "",
            path = "",
            calc = "",
        }
    }
}

-- general
lvim.log.level = 'warn'
lvim.colorscheme = 'catppuccin-latte'
lvim.format_on_save = true
lvim.transparent_window = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.cmdheight = 1
vim.opt.showtabline = 0
vim.opt.smartcase = true
-- Set window title to current file
vim.opt.title = true
vim.opt.titlestring = '%t - Vim'
require('wezterm_helper').save_old_title()
-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = 'space'
-- Disable arrow keys
lvim.keys.normal_mode['<Up>'] = '<NOP>'
lvim.keys.normal_mode['<Down>'] = '<NOP>'
lvim.keys.normal_mode['<Left>'] = '<NOP>'
lvim.keys.normal_mode['<Right>'] = '<NOP>'
-- Neovim settings that I like
--Set highlight on search
vim.o.hlsearch = false
-- Disable mouse.
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

-- disable nvim intro
vim.opt.shortmess:append 'sI'
vim.g.ultest_summary_width = 30
vim.opt.cursorline = false
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.termguicolors = true
vim.opt.ttimeoutlen = 10
vim.opt.wrapscan = true -- Searches wrap around the end of the file
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldlevel = 4
vim.wo.foldnestmax = 3
vim.wo.foldminlines = 1
vim.opt.pumblend = 10
vim.opt.mouse = 'c' -- disable mouse
vim.opt.joinspaces = false
vim.opt.list = true
vim.opt.confirm = false -- make vim prompt me to save before doing destructive things
vim.opt.autowriteall = true -- automatically :write before running commands and changing files
vim.opt.clipboard = 'unnamedplus'
vim.o.splitbelow = true
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
-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append '<>[]hl'
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

local headless = #vim.api.nvim_list_uis() == 0
if vim.g.neovide or headless then
  local sysname = vim.loop.os_uname().sysname
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_trail_length = 0.05
  vim.g.neovide_cursor_antialiasing = true
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_input_use_logo = true
  vim.g.neovide_cursor_vfx_mode = 'ripple'
  vim.g.neovide_transparency = 0.9
  vim.g.neovide_hide_mouse_when_typing = true
  if sysname == 'Darwin' then
    vim.opt.guifont = 'JetBrainsMono Nerd Font Mono:h18'
  elseif sysname == 'Linux' then
    vim.opt.guifont = 'JetBrainsMono Nerd Font Mono:h16'
  else
    vim.opt.guifont = 'JetBrainsMono Nerd Font Mono:h18'
  end
end

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = false
lvim.builtin.terminal.active = true
lvim.builtin.illuminate.active = false
lvim.builtin.nvimtree.setup.view.side = 'left'
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.bufferline.active = false
lvim.builtin.bufferline.options.always_show_bufferline = false
lvim.builtin.cmp.experimental.ghost_text = false
lvim.builtin.cmp.cmdline.enable = false
lvim.builtin.indentlines.options.show_current_context = false
-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  'bash',
  'c',
  'javascript',
  'json',
  'lua',
  'python',
  'typescript',
  'tsx',
  'css',
  'rust',
  'java',
  'yaml',
}

lvim.builtin.treesitter.ignore_install = { 'haskell' }
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.indent.enable = false
lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.treesitter.incremental_selection = {
  enable = true,
  keymaps = {
    init_selection = '<C-n>',
    node_incremental = '<C-n>',
    node_decremental = '<C-r>',
    scope_incremental = '<C-s>',
  },
}
lvim.builtin.telescope.defaults.path_display = { 'absolute' }

-- generic LSP settings
-- Formatter and Linter
local null_ls = require 'null-ls'

local sources = {
  null_ls.builtins.formatting.prettier,
  null_ls.builtins.formatting.eslint,
  null_ls.builtins.formatting.stylua,
}

null_ls.register { sources = sources }

-- we will setup the language servers later
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, {
  'rust_analyzer',
})

-- Additional Plugins
lvim.plugins = {
  { 'sainnhe/gruvbox-material' },
  {
    'catppuccin/nvim',
    as = 'catppuccin',
    config = function()
      vim.g.catppuccin_flavour = 'latte' -- latte, frappe, macchiato, mocha
      require('catppuccin').setup()
      vim.api.nvim_command 'colorscheme catppuccin'
    end,
  },
  { 'wakatime/vim-wakatime' },
  { 'stevearc/dressing.nvim' },
  {
    'zbirenbaum/copilot.lua',
    event = { 'VimEnter' },
    config = function()
      vim.defer_fn(function()
        require('copilot').setup {
          plugin_manager_path = get_runtime_dir() .. '/site/pack/packer',
          suggestion = {
            enabled = true,
            auto_trigger = true,
            debounce = 75,
            keymap = {
              accept = '<C-h>',
              next = '<M-]>',
              prev = '<M-[>',
              dismiss = '<C-]>',
            },
          },
        }
      end, 100)
    end,
  },
  { 'zbirenbaum/copilot-cmp', after = { 'copilot.lua', 'nvim-cmp' } },
  {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup {
        text = {
          spinner = 'circle_halves',
        },
      }
    end,
  },
  {
    'folke/lsp-colors.nvim',
    event = 'BufRead',
  },
  {
    'ray-x/lsp_signature.nvim',
    event = 'BufRead',
    config = function()
      require('lsp_signature').on_attach()
    end,
  },
  { 'p00f/nvim-ts-rainbow' },
  {
    'romgrk/nvim-treesitter-context',
    config = function()
      require('treesitter-context').setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          -- For all filetypes
          -- Note that setting an entry here replaces all other patterns for this entry.
          -- By setting the 'default' entry below, you can control which nodes you want to
          -- appear in the context window.
          default = {
            'class',
            'function',
            'method',
          },
        },
      }
    end,
  },
  {
    'simrat39/rust-tools.nvim',
    config = function()
      local status_ok, rust_tools = pcall(require, 'rust-tools')
      if not status_ok then
        return
      end

      local opts = {
        tools = {
          executor = require('rust-tools/executors').termopen, -- can be quickfix or termopen
          reload_workspace_from_cargo_toml = true,
          inlay_hints = {
            auto = true,
            only_current_line = false,
            show_parameter_hints = true,
            parameter_hints_prefix = '<- ',
            other_hints_prefix = '=> ',
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            right_align_padding = 7,
            highlight = 'Comment',
          },
          hover_actions = {
            border = {
              { '╭', 'FloatBorder' },
              { '─', 'FloatBorder' },
              { '╮', 'FloatBorder' },
              { '│', 'FloatBorder' },
              { '╯', 'FloatBorder' },
              { '─', 'FloatBorder' },
              { '╰', 'FloatBorder' },
              { '│', 'FloatBorder' },
            },
            auto_focus = true,
          },
        },
        server = {
          on_attach = require('lvim.lsp').common_on_attach,
          on_init = require('lvim.lsp').common_on_init,
          settings = {
            ['rust-analyzer'] = {
              checkOnSave = {
                command = 'clippy',
                extraArgs = { '--tests' },
              },
              inlayHints = { locationLinks = false },
              files = {
                -- Execlude node_modules.
                execludeDirs = { 'tests/node_modules', 'node_modules' },
              },
            },
          },
        },
      }
      rust_tools.setup(opts)
    end,
  },
  {
    'kevinhwang91/nvim-bqf',
    event = { 'BufRead', 'BufNew' },
    config = function()
      require('bqf').setup {
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = {
            '┃',
            '┃',
            '━',
            '━',
            '┏',
            '┓',
            '┗',
            '┛',
            '█',
          },
        },
        func_map = {
          vsplit = '',
          ptogglemode = 'z,',
          stoggleup = '',
        },
        filter = {
          fzf = {
            action_for = { ['ctrl-s'] = 'split' },
            extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', '> ' },
          },
        },
      }
    end,
  },
  -- Neogit
  {
    'TimUntersberger/neogit',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('neogit').setup {
        integrations = {
          diffview = true,
        },
      }
    end,
  },
  {
    'folke/trouble.nvim',
    cmd = 'TroubleToggle',
  },
  -- You must install glow globally
  -- https://github.com/charmbracelet/glow
  {
    'npxbr/glow.nvim',
    ft = { 'markdown' },
  },
  {
    'folke/todo-comments.nvim',
    event = 'BufRead',
    config = function()
      require('todo-comments').setup()
    end,
  },
  { 'sheerun/vim-polyglot' },
  {
    'andweeb/presence.nvim',
    config = function()
      -- The setup config table shows all available config options with their default values:
      require('presence'):setup {
        -- General options
        auto_update = true, -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
        neovim_image_text = 'Building the future!', -- Text displayed when hovered over the Neovim image
        main_image = 'file', -- Main image display (either "neovim" or "file")
        client_id = '793271441293967371', -- Use your own Discord application client id (not recommended)
        log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
        debounce_timeout = 8, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
        enable_line_number = true, -- Displays the current line number instead of the current project
        blacklist = {}, -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
        buttons = false,
        file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)

        -- Rich Presence text options
        editing_text = 'Editing %s', -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
        file_explorer_text = 'Browsing %s', -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
        git_commit_text = 'Committing changes', -- Format string rendered when committing changes in git (either string or function(filename: string): string)
        plugin_manager_text = 'Managing plugins', -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
        reading_text = 'Reading %s', -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
        workspace_text = 'Working on %s', -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
        line_number_text = 'Line %s out of %s', -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
      }
    end,
  },
  {
    'romgrk/fzy-lua-native',
    run = 'make',
  },
  {
    'gelguy/wilder.nvim',
    config = function()
      local wilder = require 'wilder'
      wilder.setup { modes = { ':', '/', '?' } }
      -- Disable Python remote plugin
      wilder.set_option('use_python_remote_plugin', 0)

      wilder.set_option('pipeline', {
        wilder.branch(
          wilder.cmdline_pipeline {
            fuzzy = 1,
            fuzzy_filter = wilder.lua_fzy_filter(),
          },
          wilder.vim_search_pipeline()
        ),
      })

      wilder.set_option(
        'renderer',
        wilder.renderer_mux {
          [':'] = wilder.popupmenu_renderer {
            highlighter = {
              wilder.lua_pcre2_highlighter(), -- requires `luarocks install pcre2`
              wilder.lua_fzy_highlighter(), -- requires fzy-lua-native vim plugin found
              -- at https://github.com/romgrk/fzy-lua-native
            },
            highlights = {
              accent = wilder.make_hl(
                'WilderAccent',
                'Pmenu',
                { { a = 1 }, { a = 1 }, { foreground = '#f4468f' } }
              ),
            },
            left = {
              ' ',
              wilder.popupmenu_devicons(),
            },
            right = {
              ' ',
              wilder.popupmenu_scrollbar(),
            },
          },
          ['/'] = wilder.wildmenu_renderer {
            highlighter = wilder.lua_fzy_highlighter(),
          },
        }
      )
    end,
  },
}

-- Configure Copilot:
lvim.builtin.cmp.formatting.source_names['copilot'] = '(Copilot)'
table.insert(lvim.builtin.cmp.sources, 1, { name = 'copilot' })

-- Configure gitsigns:
lvim.builtin.gitsigns.opts.current_line_blame = true
lvim.builtin.gitsigns.opts.current_line_blame_formatter_opts.relative_time =
  true

-- Configure trouble:
lvim.builtin.which_key.mappings['t'] = {
  name = 'Diagnostics',
  t = { '<cmd>TroubleToggle<cr>', 'trouble' },
  w = { '<cmd>TroubleToggle workspace_diagnostics<cr>', 'workspace' },
  d = { '<cmd>TroubleToggle document_diagnostics<cr>', 'document' },
  q = { '<cmd>TroubleToggle quickfix<cr>', 'quickfix' },
  l = { '<cmd>TroubleToggle loclist<cr>', 'loclist' },
  r = { '<cmd>TroubleToggle lsp_references<cr>', 'references' },
}

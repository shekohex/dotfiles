local M = {}
M.setup = function()
  local options = {
    defaults = {
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
      },
      prompt_prefix = '   ',
      selection_caret = '  ',
      entry_prefix = '  ',
      initial_mode = 'insert',
      selection_strategy = 'reset',
      sorting_strategy = 'ascending',
      layout_strategy = 'horizontal',
      layout_config = {
        horizontal = {
          prompt_position = 'top',
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      file_sorter = require('telescope.sorters').get_fuzzy_file,
      file_ignore_patterns = { 'node_modules' },
      generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
      path_display = { 'truncate' },
      winblend = 0,
      border = {},
      borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
      color_devicons = true,
      use_less = true,
      set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
      file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
      -- Developer configurations: Not meant for general override
      buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
      mappings = {
        n = { ['q'] = require('telescope.actions').close },
      },
    },
    file_ignore_patterns = {
      'vendor/*',
      '%.lock',
      '__pycache__/*',
      '%.sqlite3',
      '%.ipynb',
      'node_modules/*',
      '%.jpg',
      '%.jpeg',
      '%.png',
      '%.svg',
      '%.otf',
      '%.ttf',
      '.git/',
      '%.webp',
      '.dart_tool/',
      '.github/',
      '.gradle/',
      '.idea/',
      '.settings/',
      '.vscode/',
      '__pycache__/',
      'build/',
      'env/',
      'gradle/',
      'node_modules/',
      'target/',
      '%.pdb',
      '%.dll',
      '%.class',
      '%.exe',
      '%.cache',
      '%.ico',
      '%.pdf',
      '%.dylib',
      '%.jar',
      '%.docx',
      '%.met',
      'smalljre_*/*',
      '.vale/',
      '%.burp',
      '%.mp4',
      '%.mkv',
      '%.rar',
      '%.zip',
      '%.7z',
      '%.tar',
      '%.bz2',
      '%.epub',
      '%.flac',
      '%.tar.gz',
      'packer_compiled.lua',
    },

    extensions = {
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
      ['ui-select'] = {
        require('telescope.themes').get_dropdown {},
      },
    },
    extensions_list = { 'themes', 'terms' },
  }
  -- Telescope
  require('telescope').setup(options)
  require('telescope').load_extension 'fzf'
  require('telescope').load_extension 'ui-select'
  require('telescope').load_extension 'zoxide'
  M.setup_telescope_which_key()
end

M.setup_ui_select = function() end

M.project_files = function()
  local opts = { previewer = false } -- define here if you want to define something
  local ok = pcall(require('telescope.builtin').git_files, opts)
  if not ok then
    require('telescope.builtin').find_files(opts)
  end
end

M.setup_telescope_which_key = function()
  local wk = require 'which-key'
  wk.register {
    ['<leader>'] = {
      f = {
        name = '+find',
        f = {
          M.project_files,
          'Find File',
        },
        b = {
          require('telescope.builtin').buffers,
          'Find Buffers',
        },
        r = {
          require('telescope.builtin').oldfiles,
          'Find Recent Files',
        },
        w = {
          require('telescope.builtin').grep_string,
          'Find a word',
        },
        g = {
          require('telescope.builtin').live_grep,
          'Live Grep',
        },
      },
    },
  }
end

return M

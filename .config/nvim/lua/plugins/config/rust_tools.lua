local M = {}

M.setup = function()
  local my_lspconfig = require 'plugins.config.lspconfig'
  require('rust-tools').setup {
    tools = {
      autoSetHints = true,
      hover_with_actions = true,
      executor = require('rust-tools/executors').termopen, -- can be quickfix or termopen
      runnables = {
        use_telescope = true,
        prompt_prefix = '  ',
        selection_caret = '  ',
        entry_prefix = '  ',
        initial_mode = 'insert',
        selection_strategy = 'reset',
        sorting_strategy = 'descending',
        layout_strategy = 'vertical',
        layout_config = {
          width = 0.3,
          height = 0.50,
          preview_cutoff = 0,
          prompt_position = 'bottom',
        },
      },
      debuggables = {
        use_telescope = true,
      },
      inlay_hints = {
        only_current_line = false,
        show_parameter_hints = true,
        parameter_hints_prefix = ' <- ',
        other_hints_prefix = ' => ',
        max_len_align = false,
        max_len_align_padding = 2,
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
      on_attach = my_lspconfig.on_attach,
      settings = {
        ['rust-analyzer'] = {
          checkOnSave = {
            command = 'clippy',
            extraArgs = { '--tests' },
          },
          files = {
            -- Execlude node_modules.
            execludeDirs = { 'tests/node_modules', 'node_modules' },
          },
        },
      },
    },
  }
end

return M

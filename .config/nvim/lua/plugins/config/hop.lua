local M = {}

M.setup = function()
  require('hop').setup {}
  M.setup_hop_which_key()
end

M.setup_hop_which_key = function()
  local wk = require 'which-key'
  wk.register {
    ['<leader>'] = {
      h = {
        name = '+hop',
        f = {
          function()
            local hop = require 'hop'
            local hint = require 'hop.hint'
            hop.hint_char1 {
              direction = hint.HintDirection.AFTER_CURSOR,
              current_line_only = true,
            }
          end,
          'Find a char after cursor',
        },
        F = {
          function()
            local hop = require 'hop'
            local hint = require 'hop.hint'
            hop.hint_char1 {
              direction = hint.HintDirection.BEFORE_CURSOR,
              current_line_only = true,
            }
          end,
          'Find a char before cursor',
        },
        t = {
          function()
            local hop = require 'hop'
            local hint = require 'hop.hint'
            hop.hint_char1 {
              direction = hint.HintDirection.AFTER_CURSOR,
              current_line_only = false,
            }
          end,
          'Find a char after cursor and stop just before it',
        },
        T = {
          function()
            local hop = require 'hop'
            local hint = require 'hop.hint'
            hop.hint_char1 {
              direction = hint.HintDirection.BEFORE_CURSOR,
              current_line_only = false,
            }
          end,
          'Find a char before cursor and stop just after it',
        },
        w = {
          function()
            local hop = require 'hop'
            hop.hint_words { current_line_only = false, inclusive_jump = true }
          end,
          'Find a word in the current buffer',
        },
      },
    },
  }
end

return M

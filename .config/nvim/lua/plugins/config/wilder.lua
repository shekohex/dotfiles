local M = {}

M.setup = function()
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
        highlighter = wilder.lua_fzy_highlighter(),
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
end

return M

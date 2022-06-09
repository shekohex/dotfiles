local M = {}

M.setup = function()
  local ls = require "luasnip"
  ls.config.set_config {
    history = true,
    update_events = 'TextChanged,TextChangedI',
    enable_autosnippets = true,
  }
  require("luasnip.loaders.from_vscode").lazy_load()
end

return M

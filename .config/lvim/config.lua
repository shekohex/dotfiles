-- Neovim
-- =========================================
lvim.format_on_save = true
lvim.leader = " " -- space
lvim.colorscheme = "gruvbox"
lvim.debug = false
vim.lsp.set_log_level "warn"
lvim.log.level = "warn"
lvim.transparent_window = false
require("user.neovim").config() -- user config

-- Customization
-- =========================================
lvim.builtin.sell_your_soul_to_devil = false -- if you want microsoft to abuse your soul
lvim.builtin.lastplace = { active = false } -- change to false if you are jumping to future
lvim.builtin.persistence = { active = true } -- change to false if you don't want persistence
lvim.builtin.presence = { active = false } -- change to true if you want discord presence
lvim.builtin.orgmode = { active = false } -- change to true if you want orgmode.nvim
lvim.builtin.dap.active = false -- change this to enable/disable debugging
lvim.builtin.fancy_statusline = { active = true } -- enable/disable fancy statusline
lvim.builtin.fancy_dashboard = { active = true } -- enable/disable fancy dashboard
lvim.builtin.fancy_rename = { active = true } -- enable/disable custom rename
lvim.builtin.harpoon = { active = true } -- use the harpoon plugin
lvim.builtin.lua_dev = { active = true } -- change this to enable/disable folke/lua_dev
lvim.builtin.test_runner = { active = true } -- change this to enable/disable vim-test, ultest
lvim.builtin.cheat = { active = true } -- enable cheat.sh integration
lvim.builtin.sql_integration = { active = false } -- use sql integration
lvim.builtin.neoscroll = { active = true } -- smooth scrolling
lvim.builtin.neoclip = { active = true, enable_persistent_history = false }
lvim.builtin.nonumber_unfocus = false -- diffrentiate between focused and non focused windows
lvim.builtin.cursorline = { active = false } -- use a bit fancier cursorline
lvim.builtin.motion_provider = "hop" -- change this to use different motion providers ( hop or lightspeed )
lvim.builtin.hlslens = { active = false } -- enable/disable hlslens
lvim.builtin.csv_support = false -- enable/disable csv support
lvim.builtin.sidebar = { active = false } -- enable/disable sidebar
lvim.builtin.rainbow = { active = true } -- change to true if you want to enable rainbow colors.
lvim.builtin.async_tasks = { active = false } -- enable/disable async tasks
lvim.builtin.noob_mode = { active = true } -- enable/disable noob mode
lvim.builtin.metals = {
  active = false, -- enable/disable nvim-metals for scala development
  fallbackScalaVersion = "2.13.7",
  serverVersion = "0.10.9+271-a8bb69f6-SNAPSHOT",
}
lvim.builtin.file_browser = { active = false } -- enable/disable telescope file browser
lvim.builtin.sniprun = { active = false } -- enable/disable sniprun
lvim.builtin.tag_provider = "symbols-outline" -- change this to use different tag providers ( symbols-outline or vista )

local user = os.getenv "USER"
local is_me_on_linux = user and user == "shady"
local is_me_on_mac = user and user == "shadykhalifa"
local me = is_me_on_linux or is_me_on_mac
if me then
  lvim.builtin.nvim_web_devicons = { active = true }
  lvim.builtin.sell_your_soul_to_devil = true
  lvim.lsp.document_highlight = false
  lvim.builtin.csv_support = true
  lvim.builtin.lastplace.active = true
  lvim.builtin.async_tasks.active = true
  lvim.builtin.dap.active = true
  lvim.builtin.sql_integration.active = false
  lvim.builtin.file_browser.active = true
  lvim.builtin.bufferline.active = false
  lvim.builtin.cursorline.active = false
  lvim.builtin.rainbow.active = true
  lvim.builtin.presence.active = false
  lvim.builtin.noob_mode.active = false -- I'm not a noob lol.
end
lvim.lsp.diagnostics.virtual_text = true

lvim.builtin.notify.active = true
lvim.lsp.automatic_servers_installation = false
if lvim.builtin.cursorline.active then
  lvim.lsp.document_highlight = false
end
lvim.lsp.code_lens_refresh = true
require("user.builtin").config()

-- StatusLine
-- =========================================
if lvim.builtin.fancy_statusline.active then
  require("user.lualine").config()
end

-- Debugging
-- =========================================
if lvim.builtin.dap.active then
  require("user.dap").config()
end

-- Language Specific
-- =========================================
vim.list_extend(lvim.lsp.override, {
  "clangd",
  "dockerls",
  "gopls",
  "pyright",
  "r_language_server",
  "rust_analyzer",
  "sumneko_lua",
  "texlab",
  "tsserver",
  "yamlls",
})

require("user.null_ls").config()

-- Additional Plugins
-- =========================================
require("user.plugins").config()

-- Autocommands
-- =========================================
require("user.autocommands").config()

-- Additional keybindings
-- =========================================
require("user.keybindings").config()

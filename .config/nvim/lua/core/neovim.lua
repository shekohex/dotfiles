-- Contains Neovim/Vim API and Settings.

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
vim.o.background = 'light'
vim.cmd 'colorscheme gruvbox'

-- Enable Title
vim.opt.title = true

-- disable nvim intro
vim.opt.shortmess:append 'sI'
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
vim.opt.ttimeoutlen = 10
vim.opt.wrapscan = true -- Searches wrap around the end of the file
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldlevel = 4
vim.wo.foldnestmax = 3
vim.wo.foldminlines = 1
vim.opt.cmdheight = 1
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
  if sysname == 'Darwin' then
    vim.opt.guifont = 'Iosevka Nerd Font:h18'
  elseif sysname == 'Linux' then
    vim.opt.guifont = 'Iosevka Nerd Font:h14'
  else
    vim.opt.guifont = 'Iosevka Nerd Font:h18'
  end
  vim.api.nvim_set_keymap(
    '',
    '<D-v>',
    '+p<CR>',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    '!',
    '<D-v>',
    '<C-R>+',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    't',
    '<D-v>',
    '<C-R>+',
    { noremap = true, silent = true }
  )
  vim.api.nvim_set_keymap(
    'v',
    '<D-v>',
    '<C-R>+',
    { noremap = true, silent = true }
  )
end


-- Set completeopt to have a better completion experience
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.o.completeopt = 'menuone,noselect'

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

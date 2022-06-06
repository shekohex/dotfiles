local M = {}

M.setup = function()
  vim.g.copilot_no_tab_map = true
  vim.g.copilot_assume_mapped = true
  vim.g.copilot_tab_fallback = ''
  vim.g.copilot_filetypes = {
    ['*'] = false,
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

  M.setup_copilot_keymaps()
end

M.setup_copilot_keymaps = function()
  -- Github Copilot keymaps
  vim.keymap.set(
    'i',
    '<c-d>',
    vim.fn['copilot#Dismiss'],
    { expr = true, script = true, silent = true }
  )
  vim.keymap.set(
    'i',
    '<c-n>',
    vim.fn['copilot#Next'],
    { expr = true, script = true, silent = true }
  )
  vim.keymap.set(
    'i',
    '<c-p>',
    vim.fn['copilot#Previous'],
    { expr = true, script = true, silent = true }
  )
  vim.keymap.set(
    'i',
    '<c-h>',
    vim.fn['copilot#Accept'],
    { expr = true, script = true, silent = true }
  )
end

return M

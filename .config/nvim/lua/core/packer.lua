local M = {}

M.bootstrap = function()
  local fn = vim.fn
  local install_path = fn.stdpath 'data'
    .. '/site/pack/packer/start/packer.nvim'

  if fn.empty(fn.glob(install_path)) > 0 then
    print 'Cloning packer ..'

    fn.system {
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path,
    }
    -- install plugins + compile their configs
    vim.cmd 'packadd packer.nvim'
    require('plugins').setup()
    vim.cmd 'PackerSync'
  end
end

M.options = {
  auto_clean = true,
  compile_on_sync = true,
  git = { clone_timeout = 6000 },
  display = {
    working_sym = ' ﲊ',
    error_sym = '✗ ',
    done_sym = ' ',
    removed_sym = ' ',
    moved_sym = '',
    open_fn = function()
      return require('packer.util').float { border = 'single' }
    end,
  },
}

M.run = function(user_plugins)
  local present, packer = pcall(require, 'packer')

  if not present then
    return
  end

  packer.init(M.options)
  local system_plugins = {}
  -- merge default + user plugin table
  local default_plugins =
    vim.tbl_deep_extend('force', system_plugins, user_plugins)
  local final_table = {}
  for key, _ in pairs(default_plugins) do
    default_plugins[key][1] = key
    final_table[#final_table + 1] = default_plugins[key]
  end

  packer.startup(function(use)
    for _, v in pairs(final_table) do
      use(v)
    end
  end)
end

return M

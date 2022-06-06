local present, impatient = pcall(require, 'impatient')

if present then
  impatient.enable_profile()
end

require 'core'
require 'core.neovim'
require 'keymap'

-- setup packer + plugins
require('core.packer').bootstrap()
require('plugins').setup()

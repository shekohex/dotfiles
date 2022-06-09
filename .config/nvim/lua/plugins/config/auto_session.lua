local M = {}

M.setup = function()
  require('auto-session').setup {
    log_level = 'error',
    auto_session_enable_last_session = false,
    auto_session_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = true,
    auto_session_suppress_dirs = { '~/', '~/.config/', '~/.cache/' },
    auto_session_use_git_branch = true,
  }

  require('session-lens').setup {
    prompt_title = 'Sessions',
    previewer = false,
  }

  require('telescope').load_extension 'session-lens'
end

return M

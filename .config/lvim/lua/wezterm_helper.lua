local M = {}

-- Now, we need to execute a command to get all the active panes, filter it
-- by the current pane ID, and then read it's title.
-- The return value of this command is a json list of panes, so we need to
-- parse it as json.
local function get_current_pane_title()
  -- Read the current pane ID from the environment: $WEZTERM_PANE
  -- and store it so we can filter by it later.
  -- we also need to parse it as a number, since it is a string, fallback to -1
  local pane_id = tonumber(os.getenv 'WEZTERM_PANE') or -1
  -- Check if it is -1 and if so, that means we are not running inside a wezterm env.
  if pane_id == -1 then
    return ''
  end
  -- exec the command "wezterm cli list --format json"
  -- using vim api to exec commands.
  local output = function()
    local handle = io.popen 'wezterm cli list --format json'
    -- check if handle is valid
    if handle then
      local result = handle:read '*a'
      handle:close()
      if result == '' then
        return '[]'
      else
        return result
      end
    else
      return '[]'
    end
  end
  -- parse the output as json
  local panes = vim.fn.json_decode(output())
  -- filter the panes by the current pane ID
  local current_pane = vim.tbl_filter(function(pane)
    return pane.pane_id == pane_id
  end, panes)[1]
  -- return the title of the current pane
  return current_pane.title
end

M.save_old_title = function()
  -- Now, we need to set the old title to the current title.
  -- we do so, since vim can't get the old title, and we need to set it back.
  local old_title = get_current_pane_title()
  if old_title == '' then
    return
  end
  vim.opt.titleold = old_title or 'zsh'
end

return M

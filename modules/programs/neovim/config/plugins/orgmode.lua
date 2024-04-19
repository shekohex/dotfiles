local function config_orgmode()
  local orgmode_loaded, orgmode = pcall(require, "orgmode")
  if orgmode_loaded then
    -- orgmode.setup_ts_grammar()
    orgmode.setup({})
  end
end

config_orgmode()

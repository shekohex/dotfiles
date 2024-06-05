local function config_dressing()
  local ok, dressing = pcall(require, "dressing")
  if not ok then
    return
  end

  dressing.setup({
    -- options
  })
end

config_dressing()

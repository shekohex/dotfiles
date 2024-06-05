local function config_fidget()
  local ok, fidget = pcall(require, "fidget")
  if not ok then
    return
  end

  fidget.setup({
    text = {
      spinner = "circle_halves",
    },
  })
end

config_fidget()

local function config_gitsigns()
  local ok, gitsigns = pcall(require, "gitsigns")
  if not ok then
    return
  end

  gitsigns.setup({
    current_line_blame = false,
    current_line_blame_opts = {
      delay = 1000,
      ignore_whitespace = true,
    },
    current_line_blame_formatter = "<summary> - <author> <author_time:%R>",
  })
end

config_gitsigns()

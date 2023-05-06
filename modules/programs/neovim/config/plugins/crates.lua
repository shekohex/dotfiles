local function config_crates()
  local ok, crates = pcall(require, "crates")
  if not ok then
    return
  end

  local cmp = require("cmp")

  crates.setup({
    null_ls = {
      enabled = true,
      name = "crates.nvim",
    },
  })

  vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
    pattern = "Cargo.toml",
    callback = function()
      cmp.setup.buffer({ sources = { { name = "crates" } } })
    end,
  })
end

config_crates()

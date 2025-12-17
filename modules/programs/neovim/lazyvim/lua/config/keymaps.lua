-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

if vim.g.neovide then
  map("n", "<D-s>", ":w<CR>", { desc = "Save file" })
  map("v", "<D-c>", '"+y', { desc = "Copy to clipboard" })
  map("n", "<D-v>", '"+P', { desc = "Paste from clipboard" })
  map("v", "<D-v>", '"+P', { desc = "Paste from clipboard" })
  map("c", "<D-v>", "<C-R>+", { desc = "Paste in command mode" })
  map("i", "<D-v>", '<ESC>l"+Pli', { desc = "Paste in insert mode" })
end

map("", "<D-v>", "+p<CR>", { noremap = true, silent = true, desc = "Paste" })
map("!", "<D-v>", "<C-R>+", { noremap = true, silent = true, desc = "Paste" })
map("t", "<D-v>", "<C-R>+", { noremap = true, silent = true, desc = "Paste in terminal" })

map("n", "<leader>sd", function()
  vim.diagnostic.setloclist()
end, { desc = "Buffer Diagnostics (loclist)" })

map("n", "<leader>wd", function()
  require("snacks").picker.diagnostics()
end, { desc = "Workspace Diagnostics" })

map({ "n", "x" }, "<Up>", "k", { desc = "Move up" })
map({ "n", "x" }, "<Down>", "j", { desc = "Move down" })
map({ "n", "x" }, "<Left>", "h", { desc = "Move left" })
map({ "n", "x" }, "<Right>", "l", { desc = "Move right" })

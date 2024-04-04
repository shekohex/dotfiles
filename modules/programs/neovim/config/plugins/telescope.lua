local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    mappings = {
      i = {
        ["<C-Down>"] = function(...)
          return actions.cycle_history_next(...)
        end,
        ["<C-Up>"] = function(...)
          return actions.cycle_history_prev(...)
        end,
        ["<C-f>"] = function(...)
          return actions.preview_scrolling_down(...)
        end,
        ["<C-b>"] = function(...)
          return actions.preview_scrolling_up(...)
        end,
      },
      n = {
        ["q"] = function(...)
          return actions.close(...)
        end,
      },
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--trim", -- add this value
    },
    file_ignore_patterns = {
      ".git/",
      "node_modules/",
      "vendor/",
      -- Ignore all images and PDF files
      "*.{png,jpg,gif,svg,pdf}",
    },
  },
})

local telescope_projects_exists, _ = pcall(require, "project_nvim")

if telescope_projects_exists then
  require("telescope").load_extension("projects")
end

local function find_files_from_project_git_root()
  local function is_git_repo()
    vim.fn.system("git rev-parse --is-inside-work-tree")
    return vim.v.shell_error == 0
  end
  local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
  end
  local opts = {}
  if is_git_repo() then
    opts = {
      cwd = get_git_root(),
      hidden = true,
    }
  end
  require("telescope.builtin").find_files(opts)
end

local function live_grep_from_project_git_root()
  local function is_git_repo()
    vim.fn.system("git rev-parse --is-inside-work-tree")

    return vim.v.shell_error == 0
  end

  local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
  end

  local opts = {}

  if is_git_repo() then
    opts = {
      cwd = get_git_root(),
      hidden = true,
    }
  end

  require("telescope.builtin").live_grep(opts)
end

-- Telecope Keymaps

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>f", find_files_from_project_git_root, opts)
vim.keymap.set("n", "<leader>/", live_grep_from_project_git_root, opts)
vim.keymap.set("n", "<leader>?", function()
  require("telescope.builtin").oldfiles()
end, opts)
vim.keymap.set("n", "<leader>:", function()
  require("telescope.builtin").command_history()
end, opts)
vim.keymap.set("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts)
vim.keymap.set("n", "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", opts)
vim.keymap.set("n", "<leader>wd", "<cmd>Telescope diagnostics<cr>", opts)

if telescope_projects_exists then
  vim.keymap.set("n", "<leader>p", "<cmd>Telescope projects<cr>", opts)
end

-- Open Telescope automatically when we open vim with no arguments
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if #vim.fn.argv() == 0 then
      vim.defer_fn(function()
        find_files_from_project_git_root()
      end, 10)
    end
  end,
})

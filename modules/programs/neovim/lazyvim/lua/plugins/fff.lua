return {
  {
    "dmtrKovalenko/fff.nvim",
    lazy = false,
    opts = {
      prompt = "🪿 ",
      layout = {
        prompt_position = "bottom",
        preview_position = "right",
      },
      keymaps = {
        move_up = { "<Up>", "<C-p>" },
        move_down = { "<Down>", "<C-n>" },
      },
    },
    keys = {
      {
        "<leader>ff",
        function()
          require("fff").find_in_git_root()
        end,
        desc = "Find Files (fff)",
      },
      {
        "<leader>fF",
        function()
          require("fff").find_files()
        end,
        desc = "Find Files cwd (fff)",
      },
      {
        "<leader><space>",
        function()
          require("fff").find_in_git_root()
        end,
        desc = "Find Files (fff)",
      },
    },
  },
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>ff", false },
      { "<leader>fF", false },
      { "<leader><space>", false },
    },
  },
}

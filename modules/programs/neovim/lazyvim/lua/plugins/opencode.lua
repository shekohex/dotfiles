return {
  {
    "sudo-tee/opencode.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          anti_conceal = { enabled = false },
          file_types = { "markdown", "opencode_output" },
        },
        ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
      },
      "saghen/blink.cmp",
      "folke/snacks.nvim",
    },
    opts = {
      preferred_picker = "snacks",
      preferred_completion = "blink",
      default_global_keymaps = true,
      default_mode = "build",
      ui = {
        position = "left",
        input_position = "bottom",
        window_width = 0.40,
        input_height = 0.15,
        icons = {
          preset = "nerdfonts",
        },
        input = {
          text = {
            wrap = true,
          },
        },
        output = {
          tools = {
            show_output = true,
          },
        },
      },
      debug = {
        enabled = false,
      },
      context = {
        enabled = true,
        cursor_data = {
          enabled = true,
        },
        diagnostics = {
          info = false,
          warn = true,
          error = true,
        },
        current_file = {
          enabled = true,
        },
        selection = {
          enabled = true,
        },
      },
      hooks = {
        on_done_thinking = function()
          vim.notify("Opencode done thinking!", vim.log.levels.INFO)
        end,
      },
      keymap = {
        editor = {
          ["<leader>og"] = { "toggle" },
          ["<leader>oi"] = { "open_input" },
          ["<leader>oI"] = { "open_input_new_session" },
          ["<leader>oo"] = { "open_output" },
          ["<leader>ot"] = { "toggle_focus" },
          ["<leader>oT"] = { "timeline" },
          ["<leader>oq"] = { "close" },
          ["<leader>os"] = { "select_session" },
          ["<leader>oR"] = { "rename_session" },
          ["<leader>om"] = { "configure_provider" },
          ["<leader>oz"] = { "toggle_zoom" },
          ["<leader>ov"] = { "paste_image" },
          ["<leader>od"] = { "diff_open" },
          ["<leader>o]"] = { "diff_next" },
          ["<leader>o["] = { "diff_prev" },
          ["<leader>oc"] = { "diff_close" },
          ["<leader>ora"] = { "diff_revert_all_last_prompt" },
          ["<leader>ort"] = { "diff_revert_this_last_prompt" },
          ["<leader>orA"] = { "diff_revert_all" },
          ["<leader>orT"] = { "diff_revert_this" },
          ["<leader>orr"] = { "diff_restore_snapshot_file" },
          ["<leader>orR"] = { "diff_restore_snapshot_all" },
          ["<leader>ox"] = { "swap_position" },
          ["<leader>opa"] = { "permission_accept" },
          ["<leader>opA"] = { "permission_accept_all" },
          ["<leader>opd"] = { "permission_deny" },
        },
        input_window = {
          ["<cr>"] = { "submit_input_prompt", mode = { "n", "i" } },
          ["<esc>"] = { "close" },
          ["<C-c>"] = { "cancel" },
          ["~"] = { "mention_file", mode = "i" },
          ["@"] = { "mention", mode = "i" },
          ["/"] = { "slash_commands", mode = "i" },
          ["#"] = { "context_items", mode = "i" },
          ["<M-v>"] = { "paste_image", mode = "i" },
          ["<C-i>"] = { "focus_input", mode = { "n", "i" } },
          ["<tab>"] = { "toggle_pane", mode = { "n", "i" } },
          ["<up>"] = { "prev_prompt_history", mode = { "n", "i" } },
          ["<down>"] = { "next_prompt_history", mode = { "n", "i" } },
          ["<M-m>"] = { "switch_mode" },
        },
        output_window = {
          ["<esc>"] = { "close" },
          ["<C-c>"] = { "cancel" },
          ["]]"] = { "next_message" },
          ["[["] = { "prev_message" },
          ["<tab>"] = { "toggle_pane", mode = { "n", "i" } },
          ["i"] = { "focus_input", "n" },
          ["<leader>oS"] = { "select_child_session" },
          ["<leader>oD"] = { "debug_message" },
          ["<leader>oO"] = { "debug_output" },
          ["<leader>ods"] = { "debug_session" },
        },
        permission = {
          accept = "a",
          accept_all = "A",
          deny = "d",
        },
      },
    },
    keys = {
      { "<leader>oo", "<cmd>Opencode<cr>", desc = "Toggle Opencode" },
      { "<leader>oi", "<cmd>Opencode open input<cr>", desc = "Opencode Input" },
      { "<leader>oq", "<cmd>Opencode close<cr>", desc = "Close Opencode" },
      { "<leader>os", "<cmd>Opencode session select<cr>", desc = "Select Session" },
      { "<leader>on", "<cmd>Opencode session new<cr>", desc = "New Session" },
      { "<leader>oR", "<cmd>Opencode session rename<cr>", desc = "Rename Session" },
      { "<leader>od", "<cmd>Opencode diff open<cr>", desc = "Open Diff" },
    },
  },
}

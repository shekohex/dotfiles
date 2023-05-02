local cmp = require("cmp")
local lspconfig = require("lspconfig")
local lspkind = require("lspkind")

-- Neoconf
require("neoconf").setup({})

local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities =
  vim.tbl_deep_extend("force", lsp_defaults.capabilities, require("cmp_nvim_lsp").default_capabilities())

-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(event)
    local map = function(m, lhs, rhs)
      local opts = { buffer = event.buf }
      vim.keymap.set(m, lhs, rhs, opts)
    end

    local buf_command = vim.api.nvim_buf_create_user_command

    buf_command(event.buf, "LspFormat", function()
      vim.lsp.buf.format()
    end, { desc = "Format buffer with language server" })

    -- LSP actions
    map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
    map("n", "gr", "<cmd>Telescope lsp_references<cr>")
    map("n", "gd", "<cmd>Telescope lsp_definitions<cr>")
    map("n", "gT", "<cmd>Telescope lsp_type_definitions<cr>")
    map("n", "gI", "<cmd>Telescope lsp_implementations<cr>")
    map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
    map("n", "gK", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
    map("i", "<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
    map("n", "gR", "<cmd>lua vim.lsp.buf.rename()<cr>")
    map({ "n", "x" }, "<leader>cf", "<cmd>lua vim.lsp.buf.format({ async = true })<cr>")
    map({ "n", "v" }, "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>")
    map("x", "<F4>", "<cmd>lua vim.lsp.buf.range_code_action()<cr>")
    map("n", "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>")
    map("n", "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>")

    -- Diagnostics
    map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
    map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
    map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
  end,
})

-- Lua LSP
require("neodev").setup({})

-- Lua
lspconfig.lua_ls.setup({})
-- Nix LSP
lspconfig.nil_ls.setup({
  settings = {
    ["nil"] = {
      formatting = { command = { "nixpkgs-fmt" } },
    },
  },
})
-- JSON LSP
lspconfig.jsonls.setup({})

-- CMP
local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = "copilot" },
    { name = "nvim_lsp" },
    { name = "buffer", max_item_count = 5, keyword_length = 3 },
    { name = "path", max_item_count = 5 },
    { name = "luasnip", max_item_count = 3 },
    { name = "nvim_lua" },
    { name = "emoji" },
    -- { name = 'treesitter' },
    -- { name = 'crates' },
    -- { name = 'orgmode' },
  }),
  mapping = {
    -- confirm selection
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),

    -- cancel completion
    ["<C-e>"] = cmp.mapping.abort(),

    -- scroll up and down in the completion documentation
    ["<C-u>"] = cmp.mapping.scroll_docs(-5),
    ["<C-d>"] = cmp.mapping.scroll_docs(5),

    -- navigate items on the list
    ["<Up>"] = cmp.mapping.select_prev_item(cmp_select_opts),
    ["<Down>"] = cmp.mapping.select_next_item(cmp_select_opts),

    -- if completion menu is visible, go to the previous item
    -- else, trigger completion menu
    ["<C-p>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item(cmp_select_opts)
      else
        cmp.complete()
      end
    end),

    -- if completion menu is visible, go to the next item
    -- else, trigger completion menu
    ["<C-n>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item(cmp_select_opts)
      else
        cmp.complete()
      end
    end),
    -- For Copilot
    ["<CR>"] = cmp.mapping.confirm({
      -- documentation says this is important.
      -- I don't know why.
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
  },
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = lspkind.cmp_format({
      mode = "symbol", -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters
      ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
      symbol_map = { Copilot = "" },
    }),
  },
})

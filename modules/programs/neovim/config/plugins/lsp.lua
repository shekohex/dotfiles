local cmp = require("cmp")
local lspconfig = require("lspconfig")
local lspkind = require("lspkind")

-- Neoconf
require("neoconf").setup({})

-- Setup Diagnostics
local diagnostic_signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(diagnostic_signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
  underline = true,
  virtual_text = {
    prefix = "",
  },
  signs = true,
  severity_sort = true,
  update_in_insert = false,
})

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
    map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>")
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
      autoArchive = true,
    },
  },
})

-- JSON LSP
lspconfig.jsonls.setup({})
-- Python LSP
lspconfig.pylsp.setup({})
lspconfig.ruff_lsp.setup({})
-- HTML LSP
lspconfig.html.setup({
  filetypes = { "html", "htmldjango" },
})
-- Beancount LSP
local main_beancount = function()
  local path = vim.loop.cwd() .. "/main.beancount"
  return path
end

lspconfig.beancount.setup({
  init_options = {
    journal_file = main_beancount(),
  },
})
-- WGSL LSP
lspconfig.wgsl_analyzer.setup({
  settings = {
    ["wgsl-analyzer"] = {},
  },
  handlers = {
    ["wgsl-analyzer/requestConfiguration"] = function()
      return {
        success = true,
        customImports = { _dummy_ = "dummy" },
        shaderDefs = {},
        trace = {
          extension = false,
          server = false,
        },
        inlayHints = {
          enabled = false,
          typeHints = false,
          parameterHints = false,
          structLayoutHints = false,
          typeVerbosity = "inner",
        },
        diagnostics = {
          typeErrors = true,
          nagaParsingErrors = false,
          nagaValidationErrors = true,
          nagaVersion = "main",
        },
      }
    end,
  },
})
-- CMP
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp",  group_index = 2 },
    { name = "copilot",   group_index = 2 },
    { name = "buffer",    max_item_count = 5, keyword_length = 3 },
    { name = "path",      max_item_count = 5 },
    { name = "luasnip",   max_item_count = 3 },
    { name = "nvim_lua" },
    { name = "emoji" },
    { name = "treesitter" },
    { name = "crates" },
    { name = "orgmode" },
    {
      name = "beancount",
      group_index = 2,
      keyword_length = 2,
      option = {
        account = main_beancount(),
      },
    },
  }),
  sorting = {
    priority_weight = 2,
    comparators = {
      require("copilot_cmp.comparators").prioritize,
      -- Below is the default comparitor list and order for nvim-cmp
      cmp.config.compare.offset,
      -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
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
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end),
  },
  formatting = {
    expandable_indicator = true,
    fields = { "abbr", "kind", "menu" },
    format = lspkind.cmp_format({
      mode = "symbol",       -- show only symbol annotations
      maxwidth = 50,         -- prevent the popup from showing more than provided characters
      ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
      symbol_map = { Copilot = "" },
    }),
  },
})

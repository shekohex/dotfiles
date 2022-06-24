local M = {}

M.setup = function()
  local cmp = require 'cmp'
  local compare = require 'cmp.config.compare'
  local tabnine_loaded, tabnine_compare = pcall(require, 'cmp_tabnine.compare')
  if not tabnine_loaded then
    tabnine_compare = function(_a, _b) end
  end
  local luasnip = require 'luasnip'
  local lspkind = require 'lspkind'
  local source_mapping = {
    buffer = "[Buffer]",
    nvim_lsp = "[LSP]",
    nvim_lua = "[Lua]",
    cmp_tabnine = "[TN]",
    path = "[Path]",
  }
  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = cmp.mapping(function(fallback)
        local is_copilot_enabled = vim.g.loaded_copilot
        local copilot_keys = ''
        if is_copilot_enabled then
          copilot_keys = vim.fn['copilot#Accept']()
        end
        if cmp.visible() then
          cmp.select_next_item()
        elseif copilot_keys ~= '' then -- prioritise copilot over snippets
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(copilot_keys, true, true, true), 'i', true)
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'cmp_tabnine', max_item_count = 5 },
      { name = 'buffer', max_item_count = 5, keyword_length = 5 },
      { name = 'path', max_item_count = 5 },
      { name = 'luasnip', max_item_count = 3 },
      { name = 'nvim_lua' },
      { name = 'calc' },
      { name = 'spell', max_item_count = 4, keyword_length = 3 },
      { name = 'emoji', max_item_count = 5, keyword_length = 3 },
      { name = 'treesitter' },
      { name = 'crates' },
      { name = 'orgmode' },
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        tabnine_compare,
        compare.offset,
        compare.exact,
        compare.score,
        compare.recently_used,
        compare.kind,
        compare.sort_text,
        compare.length,
        compare.order,
      },
    },
    formatting = {
      format = lspkind.cmp_format {
        mode = 'symbol_text',
        maxwidth = 50,
        before = function(entry, vim_item)
          vim_item.kind = lspkind.presets.default[vim_item.kind]
          local menu = source_mapping[entry.source.name]
          -- we are checking for the source name
          if entry.source.name == "cmp_tabnine" then
            if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
              menu = entry.completion_item.data.detail .. " " .. menu
            end
            vim_item.kind = ""
          end

          vim_item.menu = menu

          return vim_item
        end,
      },
    },
  }

  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline' },
    }),
  })
end

return M

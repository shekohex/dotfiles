local M = {}

M.setup = function()
  M.setup_sumneko_lua()
  M.setup_tsserver()
  M.setup_jsonls()
end

M.capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  return capabilities
end

M.on_attach = function(client, bufnr)
  M.setup_lsp_which_key(bufnr)
  vim.diagnostic.config {
    virtual_text = {
      prefix = '●', -- Could be '●', '▎', 'x'
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
  }
  local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
  local lsp_augroup = 'lsp_augroup' .. bufnr
  vim.api.nvim_create_augroup(lsp_augroup, { clear = true })
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = lsp_augroup,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.formatting_sync(nil, 5000)
    end,
  })
  vim.api.nvim_create_autocmd('CursorHold', {
    group = lsp_augroup,
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = {
          'BufLeave',
          'CursorMoved',
          'InsertEnter',
          'FocusLost',
        },
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, opts)
    end,
  })
end

M.setup_tsserver = function()
  local lspconfig = require 'lspconfig'
  lspconfig.tsserver.setup {
    on_attach = M.on_attach,
    capabilities = M.capabilities(),
  }
end

M.setup_jsonls = function()
  local lspconfig = require 'lspconfig'
  lspconfig.jsonls.setup {
    on_attach = M.on_attach,
    capabilities = M.capabilities(),
  }
end

M.setup_sumneko_lua = function()
  -- Make runtime files discoverable to the server
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')
  local lspconfig = require 'lspconfig'
  lspconfig.sumneko_lua.setup {
    on_attach = M.on_attach,
    capabilities = M.capabilities(),
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file('', true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }
end

M.setup_lsp_which_key = function(bufnr)
  local opts = { buffer = bufnr }
  local wk = require 'which-key'
  wk.register({
    g = {
      name = '+lsp',
      D = {
        vim.lsp.buf.declaration,
        'Go to Declaration',
      },
      d = {
        vim.lsp.buf.definition,
        'Go to Definition',
      },
      i = {
        vim.lsp.buf.implementation,
        'Go to Implementation',
      },
      r = {
        vim.lsp.buf.references,
        'Go to Refrences',
      },
    },
    K = {
      vim.lsp.buf.hover,
      'Hover',
    },
    ['[d'] = {
      vim.diagnostic.goto_prev,
      'Go to previous diagnostic',
    },
    [']d'] = {
      vim.diagnostic.goto_next,
      'Go to next diagnostic',
    },
    ['<leader>'] = {
      name = '+lsp',
      e = {
        vim.diagnostic.open_float,
        'Open Diagnostics',
      },
      ca = {
        vim.lsp.buf.code_action,
        'Code actions',
      },
      rn = {
        vim.lsp.buf.rename,
        'Rename',
      },
      ds = {
        require('telescope.builtin').lsp_document_symbols,
        'Document Symbols',
      },
      ws = {
        require('telescope.builtin').lsp_workspace_symbols,
        'Workspace Symbols',
      },
    },
  }, opts)
end

return M

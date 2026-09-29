return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'folke/neodev.nvim', opts = {} },
  },

  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set(
            'n',
            keys,
            func,
            { buffer = event.buf, desc = 'LSP: ' .. desc }
          )
        end

        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map(
          'gI',
          require('telescope.builtin').lsp_implementations,
          '[G]oto [I]mplementation'
        )
        map(
          '<leader>D',
          require('telescope.builtin').lsp_type_definitions,
          'Type [D]efinition'
        )
        map(
          '<leader>ds',
          require('telescope.builtin').lsp_document_symbols,
          '[D]ocument [S]ymbols'
        )
        map(
          '<leader>ws',
          require('telescope.builtin').lsp_dynamic_workspace_symbols,
          '[W]orkspace [S]ymbols'
        )
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if
          client
          and client.server_capabilities.inlayHintProvider
          and vim.lsp.inlay_hint
        then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, '[T]oggle Inlay [H]ints')
        end

        vim.diagnostic.config { virtual_text = false }
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend(
      'force',
      capabilities,
      require('cmp_nvim_lsp').default_capabilities()
    )

    local lspconfig = require 'lspconfig'

    -- Swift LSP (sourcekit-lsp ships with Xcode, not Mason)
    local sourcekit_path = vim.fn.exepath 'sourcekit-lsp'
    if sourcekit_path == '' then
      sourcekit_path = vim.fn.trim(
        vim.fn.system 'xcrun --find sourcekit-lsp 2>/dev/null'
      )
    end
    if sourcekit_path ~= '' then
      lspconfig.sourcekit.setup {
        cmd = { sourcekit_path },
        capabilities = capabilities,
        filetypes = { 'swift', 'objc', 'objcpp' },
      }
    end

    -- Ruby LSP
    local ruby_lsp_path = vim.fn.exepath 'ruby-lsp'
    if ruby_lsp_path ~= '' then
      lspconfig.ruby_lsp.setup {
        cmd = { ruby_lsp_path }, -- resolves to mise's shim
        capabilities = capabilities,
        init_options = {
          formatter = 'none', -- use conform.nvim instead for formatting
          linters = { 'rubocop' }, -- RuboCop diagnostics via bundle exec
          -- Rails add-on enables automatically when it detects Rails
          -- addonSettings = { ["Ruby LSP Rails"] = { } }
        },
      }
    end

    local servers = {
      clangd = {},
      dockerls = {},
      jsonls = {},
      lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' } } } },
      pyright = {},
      ruff = {},
      tailwindcss = {},
      terraformls = {},
      tsserver = {},
      yamlls = {},
    }

    require('mason').setup()

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      automatic_installation = true,
      ensure_installed = vim.tbl_keys(servers or {}),
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities =
            vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          lspconfig[server_name].setup(server)
        end,
      },
    }

    local signs = { Error = '●', Warn = '●', Hint = '●', Info = '' }
    for type, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
  end,
}

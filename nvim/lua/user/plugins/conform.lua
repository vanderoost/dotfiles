return { -- Autoformat
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = {
        cpp = true,
      }

      local ft = vim.bo[bufnr].filetype
      if ft == 'ruby' then
        return { timeout_ms = 3000, lsp_fallback = false } -- don't call LSP formatter
      end

      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      blade = { 'prettier' },
      c = { 'clang_format' },
      javascript = { 'prettier' },
      lua = { 'stylua' },
      php = { 'pint' },
      python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
      ruby = { 'rubocop' },
      swift = { 'swiftformat' },
    },
    formatters = {
      clang_format = {
        prepend_args = { '--style={ColumnLimit: 88}' },
      },
      rubocop = {
        -- Use project's bundled rubocop via binstub
        command = 'bin/rubocop',
        -- Override default args to remove --server flag
        args = {
          '--autocorrect-all',
          '--stderr',
          '--stdin',
          '$FILENAME',
        },
      },
    },
  },
}

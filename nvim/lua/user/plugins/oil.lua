return { -- :help oil
  'stevearc/oil.nvim',
  opts = {},
  config = function()
    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    require('oil').setup {
      win_options = {
        wrap = true,
        signcolumn = 'yes',
      },
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        ['<C-p>'] = 'actions.preview',
        ['-'] = 'actions.parent',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
      },
      use_default_keymaps = false,
      view_options = {
        is_hidden_file = function(name, _)
          return vim.startswith(name, '.')
        end,
        is_always_hidden = function(name, _)
          return false
            or name == '..'
            or name == '.DS_Store'
            or name == '.git'
            or name == '.pytest_cache'
            or name == '__pycache__'
        end,
      },
      git = {
        mv = function(_src_path, _dest_path)
          return true
        end,
      },
    }
  end,
}

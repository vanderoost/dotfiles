-- Using the built-in plugin manager. See `:help vim.pack`.
-- Update with `:lua vim.pack.update()`.

vim.pack.add { 'https://github.com/stevearc/oil.nvim' }

-- Minimal file explorer. See `:help oil`
require('oil').setup()
vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })

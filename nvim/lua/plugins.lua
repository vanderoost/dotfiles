-- Using the built-in plugin manager. See `:help vim.pack`.
-- Update with `:lua vim.pack.update()`.

vim.pack.add {
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
}

-- Minimal file explorer. See `:help oil`
require('oil').setup()
vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })

-- Telescope, see `:help telescope`
require('telescope').setup()
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers,
  { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sm', function()
  -- Sections 2 (system calls) and 3 (C library functions)
  local opts = { sections = { '2', '3' } }
  -- Match on every name of a page (e.g. "calloc, free, malloc"), not just the first
  local make_entry = require('telescope.make_entry').gen_from_apropos(opts)
  opts.entry_maker = function(line)
    local entry = make_entry(line)
    if entry then
      entry.ordinal = entry.keyword
    end
    return entry
  end
  builtin.man_pages(opts)
end, { desc = '[S]earch [M]an pages' })

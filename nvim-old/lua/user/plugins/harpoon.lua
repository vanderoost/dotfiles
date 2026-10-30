return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local harpoon = require 'harpoon'

    harpoon:setup {
      global_settings = { save_on_toggle = true, tabline = false },
    }

    local nmap = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { desc = 'Harpoon: ' .. desc })
    end

    nmap('<leader>a', function()
      harpoon:list():add()
    end, 'Add current buffer')

    nmap('<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, 'Toggle quick menu')

    nmap('<C-h>', function()
      harpoon:list():select(1)
    end, 'Jump to buffer #1')
    nmap('<C-j>', function()
      harpoon:list():select(2)
    end, 'Jump to buffer #2')
    nmap('<C-k>', function()
      harpoon:list():select(3)
    end, 'Jump to buffer #3')
    nmap('<C-l>', function()
      harpoon:list():select(4)
    end, 'Jump to buffer #4')

    -- Telescope extension
    require('telescope').load_extension 'harpoon'
  end,
}

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Basic Keymaps ]]

local nmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = desc })
end
local vmap = function(keys, func, desc)
  vim.keymap.set('v', keys, func, { desc = desc })
end

nmap('<Esc>', '<cmd>nohlsearch<CR>')
nmap('<C-S>', ':wa<CR>', 'Save all changed buffers')

-- Keep cursor centered while jumping search
nmap('n', 'nzz')
nmap('N', 'Nzz')

-- Keep cursor in place while joining lines with J
nmap('J', 'mzJ`z')

-- Moving selected lines up and down
vmap('J', ":m '>+1<CR>gv=gv")
vmap('K', ":m '<-2<CR>gv=gv")

-- Change the text under the cursor and be able to repeat it on every occurrence
nmap('c*', '*Ncgn')

nmap('<leader>e', vim.diagnostic.open_float, 'Show diagnostic [E]rror messages')
nmap('<leader>q', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

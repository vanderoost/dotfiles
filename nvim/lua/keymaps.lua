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

-- Up and down for scrolling
nmap('<Up>', '<C-y>')
nmap('<Down>', '<C-e>')

nmap('<leader>e', vim.diagnostic.open_float, 'Show diagnostic [E]rror messages')
nmap('<leader>q', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')

-- Run :make quietly, open the quickfix window on errors/warnings and report the result
nmap('gm', function()
  vim.cmd 'silent make'
  vim.cmd 'cwindow'
  if vim.v.shell_error == 0 then
    vim.notify 'make: ok'
  elseif vim.tbl_isempty(vim.fn.getqflist()) then
    -- Failed without parsable errors (e.g. a linker error), so the quickfix is empty
    vim.notify('make: failed (run :make to see the output)', vim.log.levels.ERROR)
  end
end, 'Run the :make command')

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

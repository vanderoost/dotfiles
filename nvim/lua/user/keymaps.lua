-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

local nmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = desc })
end
local vmap = function(keys, func, desc)
  vim.keymap.set('v', keys, func, { desc = desc })
end

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
nmap('<Esc>', '<cmd>nohlsearch<CR>')

nmap('<C-S>', ':wa<CR>', 'Save all changed buffers')

-- Keep cursor centered while jumping search
nmap('n', 'nzz')
nmap('N', 'Nzz')
nmap(']]', ']]zz')
nmap('[[', '[[zz')

-- Keep cursor in place while joining lines with J
nmap('J', 'mzJ`z')

-- Moving selected lines up and down
vmap('J', ":m '>+1<CR>gv=gv")
vmap('K', ":m '<-2<CR>gv=gv")

-- Change the text under the cursor and be able to repeat it on every occurrence
nmap('c*', '*Ncgn')

-- Make scrolling nicer with trackpad (trackpad scroll uses arrow up/down)
nmap('<Up>', '<C-y>')
nmap('<Down>', '<C-e>')

-- Delete all buffers except the current one
-- wa => write all buffers that were changed
-- %bd => delete all buffers
-- e# => edit the last buffer
-- bd# => delete the weird No-name buffer that's created
-- <CR> => execute the command
-- <C-o> => restore the cursor position
nmap('<leader>o', ':wa|%bd|e#|bd#<CR><C-o>', 'Make the current buffer the [O]nly one')

nmap('[B', ':bfirst<CR>', 'Go to first buffer')
nmap(']B', ':blast<CR>', 'Go to last buffer')
nmap('[b', ':bprevious<CR>', 'Go to previous buffer')
nmap(']b', ':bnext<CR>', 'Go to next buffer')
nmap('[Q', ':cfirst<CR>', 'Go to first quickfix item')
nmap(']Q', ':clast<CR>', 'Go to last quickfix item')
nmap('[q', ':cprevious<CR>', 'Go to previous quickfix item')
nmap(']q', ':cnext<CR>', 'Go to next quickfix item')

-- Diagnostic keymaps
nmap('[d', vim.diagnostic.goto_prev, 'Go to previous [D]iagnostic message')
nmap(']d', vim.diagnostic.goto_next, 'Go to next [D]iagnostic message')
nmap('<leader>e', vim.diagnostic.open_float, 'Show diagnostic [E]rror messages')
nmap('<leader>q', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Gitsigns
nmap(
  '<leader>b',
  ':Gitsigns toggle_current_line_blame<CR>',
  'Toggle git blame for current line'
)
nmap('<leader>h', ':Gitsigns preview_hunk_inline<CR>', 'Preview hunks inline')

nmap('gm', ':make<CR>', 'Run the :make command')

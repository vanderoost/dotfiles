local function status_line()
  return vim.fn.expand '%'
end
vim.opt.statusline = status_line()

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Tab width and stuff
vim.opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4 -- insert 4 spaces for a tab
vim.opt.expandtab = true -- convert tabs to spaces

vim.opt.textwidth = 88

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

-- Remove status line to get more screen space
vim.opt.laststatus = 0

-- No mouse please
vim.opt.mouse = ''

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Add commenting functionality to Terraform files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'terraform',
  callback = function()
    vim.bo.commentstring = '# %s'
  end,
})

-- For C / C++ files, use gcc compiler and ignore non-diagnostic lines
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'c', 'cpp', 'h' },
  callback = function()
    -- Clang formatter uses tabwidth of 2
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2

    -- Use gcc compiler plugin
    vim.cmd 'compiler gcc'

    -- Use make -B so it always rebuilds
    vim.opt_local.makeprg = 'make -B'

    -- Ignore non-diagnostic lines in quickfix
    vim.cmd 'setlocal errorformat+=,%-G%.%#'
  end,
})

-- Treat .h files as C instead of C++
vim.g.c_syntax_for_h = 1

-- Format options for comments (remove o to not insert a comment after pressing o)
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.opt_local.formatoptions:remove { 'o' }
  end,
})

-- LICENCE files are of type text
vim.filetype.add { filename = { LICENSE = 'text', LICENCE = 'text' } }

-- Echo the file name when entering a buffer for better orientation
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Echo the file name when entering a buffer',
  group = vim.api.nvim_create_augroup('user-echo-file-name', { clear = true }),
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)

    -- Only for real files: skips help, quickfix, terminals, prompts, ...
    if name == '' or vim.bo[args.buf].buftype ~= '' then
      return
    end

    -- Also skip anything behind a URL scheme, such as 'oil:///home/me/'
    if name:match '^%a[%w+.-]*://' then
      return
    end

    local label = vim.fn.fnamemodify(name, ':~:.')
    if vim.bo[args.buf].modified then
      label = label .. ' [+]'
    end

    -- Truncate from the left, so a long path can never cause a "Press ENTER" prompt.
    -- 'v:echospace' is the exact number of cells we can use
    local max_width = vim.v.echospace
    if #label > max_width then
      label = '<' .. label:sub(-(max_width - 1))
    end

    -- `false` keeps these out of `:messages`
    vim.api.nvim_echo({ { label } }, false, {})
  end,
})

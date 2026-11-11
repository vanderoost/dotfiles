-- [[ Options ]]
-- See `:help option-list`

vim.opt.shortmess:append("I")

vim.o.cmdheight = 0

vim.o.clipboard = 'unnamedplus'

vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.textwidth = 88

vim.o.breakindent = true
vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split'
vim.o.scrolloff = 8
vim.o.mouse = ''
vim.o.winborder = 'rounded'

-- [[ Autocommands ]]

-- Transparent statusline
local transparent_group = vim.api.nvim_create_augroup('user-transparent-bg',
  { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = transparent_group,
  command = [[
    highlight StatusLine guifg=fg guibg=NONE
    highlight! link StatusLineNC Comment
  ]],
})
-- Reload the scheme when Neovim follows Ghostty's light/dark mode switching
vim.api.nvim_create_autocmd('OptionSet', {
  group = transparent_group,
  pattern = 'background',
  nested = true,
  command = 'colorscheme tokyonight',
})

-- With cmdheight=0 there's no "recording @q" message, so show it in the statusline
vim.o.statusline = "%{reg_recording() != '' ? 'recording @' .. reg_recording() .. ' ' : ''}"
    .. vim.api.nvim_get_option_info2('statusline', {}).default
vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
  group = vim.api.nvim_create_augroup('user-recording-status', { clear = true }),
  callback = function()
    -- reg_recording() is still set during RecordingLeave, so redraw after it
    vim.schedule(function()
      vim.cmd.redrawstatus { bang = true }
    end)
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('user-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- For C files, parse gcc/clang output into the quickfix list on :make
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('user-c-make', { clear = true }),
  pattern = { 'c', 'cpp' },
  callback = function()
    vim.cmd 'compiler gcc'

    -- Use make -B so it always rebuilds. :make pipes the output through `tee`, so
    -- pipefail is needed for v:shell_error to hold make's exit code instead of tee's
    vim.opt_local.makeprg = 'set -o pipefail; make -B'

    -- Ignore non-diagnostic lines in quickfix
    vim.opt_local.errorformat:append '%-G%.%#'
  end,
})

-- Treat .h files as C instead of C++
vim.g.c_syntax_for_h = 1

-- [[ LSP ]]
-- Each server is configured in `lsp/<name>.lua` and turned on here.
-- The server binary itself must be on $PATH. See `:help lsp-quickstart`
-- and `:checkhealth vim.lsp` to see what's running.

vim.lsp.enable { 'clangd', 'lua_ls', 'ruff', 'ty' }

-- Highlight the first item in the completion menu, but don't insert it until accepted.
-- Navigate with <C-n>/<C-p>, accept with <C-y>, cancel with <C-e>
vim.o.completeopt = 'menuone,noinsert,popup'

vim.diagnostic.config {
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '●',
      [vim.diagnostic.severity.WARN] = '●',
      [vim.diagnostic.severity.HINT] = '●',
      [vim.diagnostic.severity.INFO] = '',
    },
  },
  -- Show the diagnostic message in a float after jumping with ]d / [d
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
    end,
  },
}

-- Built-in default LSP keymaps (no need to map them):
--   K hover, grn rename, gra code action, grr references, gri implementation,
--   grt type definition, gO document symbols, <C-S> (insert) signature help
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
  callback = function(event)
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

    -- Autocomplete. <C-Space> triggers it manually
    if client:supports_method 'textDocument/completion' then
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
      vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, { buffer = event.buf })

      -- Autotrigger only fires on the server's trigger characters (e.g. `.` or `->`),
      -- so also open the menu once a typed name is x characters long
      local group = vim.api.nvim_create_augroup('user-lsp-complete-word',
        { clear = false })
      vim.api.nvim_clear_autocmds { group = group, buffer = event.buf }
      vim.api.nvim_create_autocmd('InsertCharPre', {
        group = group,
        buffer = event.buf,
        callback = function()
          if vim.fn.pumvisible() == 1 then
            return
          end
          -- InsertCharPre runs before the typed character is in the line
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local text = vim.api.nvim_get_current_line():sub(1, col) .. vim.v.char
          local word = text:match '[%a_][%w_]*$'
          if word and #word >= 4 then
            vim.schedule(vim.lsp.completion.get)
          end
        end,
      })
    end

    -- Format on save
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('user-lsp-format', { clear = false }),
      buffer = event.buf,
      callback = function()
        if client:supports_method('textDocument/formatting', event.buf) then
          vim.lsp.buf.format { bufnr = event.buf, id = client.id, timeout_ms = 1000 }
        end
      end,
    })
  end,
})

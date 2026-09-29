return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'aklt/plantuml-syntax',
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      current_line_blame_opts = { virt_text_pos = 'overlay', ignore_whitespace = true },
    },
  },
}

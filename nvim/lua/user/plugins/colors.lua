return {
  'folke/tokyonight.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  init = function()
    vim.cmd.colorscheme 'tokyonight-night'

    -- Remove the background of all these
    local colors = {
      'ColorColumn',
      'CurSearch',
      'CursorColumn',
      'CursorLine',
      'CursorLineSign',
      'FoldColumn',
      'Folded',
      'ModeMsg',
      'MoreMsg',
      'MsgArea',
      'Normal',
      'NormalFloat',
      'NormalNC',
      'Pmenu',
      'SignColumn',
      'StatusLine',
      'StatusLineNC',
      'TabLine',
      'TabLineFill',
      'TabLineSel',
      'TelescopeBorder',
      'TelescopeNormal',
      'TelescopePromptBorder',
      'TelescopePromptTitle',
    }

    for _, color in ipairs(colors) do
      vim.cmd.hi(color .. ' guibg=none')
    end
  end,
}

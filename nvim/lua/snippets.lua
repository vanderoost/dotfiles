-- [[ Snippets ]]
-- Type a trigger word, then <C-j> to expand. <Tab>/<S-Tab> jump between placeholders.
-- Body uses LSP snippet syntax: $1, ${1:default}, $0 = final cursor position.
-- A body can also be a function returning that string, for dynamic text.
-- See `:help vim.snippet`.

local mit = [[
MIT License

Copyright (c) %s Richard van der Oost

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.]]

local snippets = {
  c = {
    main = 'int main(void) {\n\t$0\n\n\treturn 0;\n}',
    ['for'] = 'for (size_t $1 = 0; $1 < $2; ++$1) {\n\t$0\n}',
    -- Uppercased file stem, with anything non-alphanumeric turned into an
    -- underscore: plt.h -> PLT, my-plt.h -> MY_PLT
    guard = function()
      local stem = vim.fn.expand('%:t:r'):gsub('[^%w]', '_'):upper()
      return ('#ifndef _%s_H\n#define _%s_H\n\n$0\n\n#endif // _%s_H'):format(
        stem,
        stem,
        stem
      )
    end,
  },
  python = {
    main = "def main() -> int:\n    $0\n    return 0\nif __name__ == '__main__': exit(main())",
    class = 'class $1($2):\n    def __init__(self, $3):\n        self.$3 = $3',
    dataclass = '@dataclass\nclass $1:\n    $0',
    np = 'import numpy as np',
    pd = 'import pandas as pd',
  },
  markdown = {
    youtube = '[![$1](https://img.youtube.com/vi/$2/mqdefault.jpg)](https://youtu.be/$2)',
  },
  text = {
    mit = function()
      return mit:format(os.date '%Y')
    end,
  },
}

vim.keymap.set('i', '<C-j>', function()
  local col = vim.fn.col '.' - 1
  local word = vim.api.nvim_get_current_line():sub(1, col):match '[%w_]+$'
  local body = word and (snippets[vim.bo.filetype] or {})[word]
  if not body then
    return
  end
  if type(body) == 'function' then
    body = body()
  end
  local row = vim.fn.line '.' - 1
  vim.api.nvim_buf_set_text(0, row, col - #word, row, col, {})
  vim.snippet.expand(body)
end, { desc = 'Expand snippet' })

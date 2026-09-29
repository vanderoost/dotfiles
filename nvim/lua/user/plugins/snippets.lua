return {
  'L3MON4D3/LuaSnip',
  build = (function()
    -- Build Step is needed for regex support in snippets.
    -- This step is not supported in many windows environments.
    -- Remove the below condition to re-enable on windows.
    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
      return
    end
    return 'make install_jsregexp'
  end)(),
  config = function()
    local luasnip = require 'luasnip'
    luasnip.config.setup {}

    local s = luasnip.s
    local i = luasnip.insert_node
    -- Snippet bodies written as plain LSP-syntax strings have to go
    -- through the parser; s() only accepts nodes.
    local ps = luasnip.parser.parse_snippet
    local fmt = require('luasnip.extras.fmt').fmt
    local rep = require('luasnip.extras').rep

    -- Uppercased file stem, with anything non-alphanumeric turned into an
    -- underscore: plt.h -> PLT, my-plt.h -> MY_PLT. Needs jsregexp (see build).
    local stem = '${TM_FILENAME_BASE/([^a-zA-Z0-9])|(.)/${1:+_}${2:/upcase}/g}'

    luasnip.add_snippets('c', {
      ps(
        'main',
        [[
int main(void) {
  $0

  return 0;
}]]
      ),
      ps(
        'for',
        [[
for (size_t $1 = 0; $1 < $2; ++$1) {
  $0
}]]
      ),
      ps(
        'guard',
        ('#ifndef _%s_H\n#define _%s_H\n\n$0\n\n#endif // _%s_H'):format(
          stem,
          stem,
          stem
        )
      ),
    })

    luasnip.add_snippets('python', {
      ps(
        'main',
        "def main() -> int:\n    $0\n    return 0\nif __name__ == '__main__': exit(main())"
      ),
      s(
        'class',
        fmt(
          'class {}({}):\n    def __init__(self, {}):\n        self.{} = {}',
          { i(1), i(2), i(3), rep(3), rep(3) }
        )
      ),
      ps('dataclass', '@dataclass\nclass $1:\n    $0'),
      ps('np', 'import numpy as np'),
      ps('pd', 'import pandas as pd'),
    })

    luasnip.add_snippets('markdown', {
      ps(
        'youtube',
        '[![$1](https://img.youtube.com/vi/$2/mqdefault.jpg)](https://youtu.be/$2)'
      ),
    })

    luasnip.add_snippets('text', {
      ps(
        'mit',
        [[
MIT License

Copyright (c) $CURRENT_YEAR Richard van der Oost

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
      ),
    })
  end,
}

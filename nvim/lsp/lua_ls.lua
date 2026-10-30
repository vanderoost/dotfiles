---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.stylua.toml', '.git' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      -- Make the server aware of Neovim's runtime files, so `vim.*` is known
      workspace = { library = { vim.env.VIMRUNTIME }, checkThirdParty = false },
    },
  },
}

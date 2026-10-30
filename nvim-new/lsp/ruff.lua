-- Organize imports on save, since ruff's formatter doesn't sort them
local function organize_imports(client, bufnr)
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(bufnr),
    range = {
      start = { line = 0, character = 0 },
      ['end'] = { line = vim.api.nvim_buf_line_count(bufnr), character = 0 },
    },
    context = { only = { 'source.organizeImports' }, diagnostics = {} },
  }
  local response = client:request_sync('textDocument/codeAction', params, 1000, bufnr)
  for _, action in ipairs(response and response.result or {}) do
    -- Ruff may leave out the edit until the action is resolved
    if not action.edit and client:supports_method 'codeAction/resolve' then
      local resolved = client:request_sync('codeAction/resolve', action, 1000, bufnr)
      action = resolved and resolved.result or action
    end
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    end
  end
end

---@type vim.lsp.Config
return {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('user-ruff-organize-imports', { clear = false }),
      buffer = bufnr,
      callback = function()
        organize_imports(client, bufnr)
      end,
    })
  end,
}

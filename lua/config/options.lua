vim.diagnostic.config {
  update_in_insert = true,
  float = {
    focusable = false,
  },
  signs = true,
  underline = true,
  virtual_text = false,
  severity_sort = true,
}
<<<<<<< HEAD
=======

local signs = { Error = '󰅚', Warn = '󰀪', Hint = '󰌶', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.cmd(('sign define %s text=%s texthl=%s numhl= '):format(hl, icon, hl))
  hl = 'LspDiagnosticSign' .. type
  vim.cmd(('sign define %s text=%s texthl=%s numhl= '):format(hl, icon, hl))
end
>>>>>>> 59001e7a4709e4f1ec8a3f53eaec2508008cc44d

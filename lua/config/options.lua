vim.opt.termguicolors = true

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

local signs = { Error = '󰅚', Warn = '󰀪', Hint = '󰌶', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.cmd(('sign define %s text=%s texthl=%s numhl= '):format(hl, icon, hl))
  hl = 'LspDiagnosticSign' .. type
  vim.cmd(('sign define %s text=%s texthl=%s numhl= '):format(hl, icon, hl))
end

vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Detect terminal & disable line highlight',
  pattern = 'term://*',
  callback = function(params)
    local winnr = vim.fn.bufwinid(params.buf)
    vim.api.nvim_set_option_value('cursorline', false, { win = winnr })
  end,
})

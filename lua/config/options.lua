vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.termguicolors = true

vim.opt.backspace = 'indent,eol,start'

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

vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

local signs = { Error = '󰅚', Warn = '󰀪', Hint = '󰌶', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.cmd(('sign define %s text=%s texthl=%s numhl= '):format(hl, icon, hl))
  hl = 'LspDiagnosticSign' .. type
  vim.cmd(('sign define %s text=%s texthl=%s numhl= '):format(hl, icon, hl))
end

-- maybe separate file ?
vim.filetype.add {
  filename = {
    ['kitty.conf'] = 'kitty',
    ['yabairc'] = 'bash',
  },
}

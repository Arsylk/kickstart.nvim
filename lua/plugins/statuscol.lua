return {
  {
    'luukvbaal/statuscol.nvim',
    config = function()
      local builtin = require 'statuscol.builtin'
      return {
        relculright = true,
        ft_ignore = { 'neo-tree', 'neo-tree-popup', 'alpha', 'lazy', 'mason', 'dashboard' },
        segments = {
          { text = { builtin.lnumfunc }, click = 'v:lua.ScLa' },
          {
            sign = { name = { 'Diagnostic*' }, text = { '.*' }, maxwidth = 1, colwidth = 1, auto = true },
            click = 'v:lua.ScSa',
          },
          { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
        },
      }
    end,
  },
}

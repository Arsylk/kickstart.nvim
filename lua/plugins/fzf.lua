return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      keymap = {
        fzf = {
          ['ctrl-q'] = 'select-all+accept',
        },
      },
    },
    config = function(_, opts)
      require('fzf-lua').setup(opts)
      local ui_select = require 'fzf-lua.providers.ui_select'
      ui_select.register(opts, false, opts)
    end,
  },
}

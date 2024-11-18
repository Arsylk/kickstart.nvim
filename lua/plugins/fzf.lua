return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = function()
      local actions = require 'fzf-lua.actions'
      return {
        keymap = {
          builtin = {
            false,
            ['<F1>'] = 'toggle-help',
            ['<F2>'] = 'toggle-preview',
          },
          fzf = {
            ['ctrl-q'] = 'select-all+accept',
            ['ctrl-a'] = 'toggle-all',
          },
        },
      }
    end,
  },
}

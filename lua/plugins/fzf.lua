return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      keymap = {
        builtin = {
          false,
          ['<F1>'] = 'toggle-help',
          ['<F2>'] = 'toggle-preview',
        },
        fzf = {
          ['ctrl-a'] = 'toggle-all',
          ['ctrl-q'] = 'select-all+accept',
        },
      },
    },
  },
}

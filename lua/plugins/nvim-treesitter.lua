return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'RRethy/nvim-treesitter-textsubjects',
    },
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        ensure_installed = { 'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = {
        enable = true,
        disable = { 'ruby' },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = { query = '@function.outer', desc = 'function outer' },
            ['if'] = { query = '@function.inner', desc = 'function inner' },
            ['ab'] = { query = '@block.outer', desc = 'block outer' },
            ['ib'] = { query = '@block.inner', desc = 'block inner' },
            ['ac'] = { query = '@class.outer', desc = 'class outer' },
            ['ic'] = { query = '@class.inner', desc = 'class inner' },
          },
        },
      },
      textsubjects = {
        enable = true,
        prev_selection = ',',
        keymaps = {
          ['.'] = { 'textsubjects-smart', desc = 'textsubject smart' },
          [';'] = { 'textsubjects-container-outer', desc = 'textsubject container outer' },
          ['i;'] = { 'textsubjects-container-inner', desc = 'textsubject container inner' },
        },
      },
    },
    config = function(_, opts)
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}

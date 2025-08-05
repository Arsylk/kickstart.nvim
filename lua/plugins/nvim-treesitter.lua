return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'RRethy/nvim-treesitter-textsubjects',
      'chrisgrieser/nvim-various-textobjs',
    },
    build = ':TSUpdate',
    --- @type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        ensure_installed = { 'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'vim', 'vimdoc' },
        additional_vim_regex_highlighting = { 'ruby' },
        disable = { 'blutter' },
      },
      indent = {
        enable = true,
        disable = { 'ruby' },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = 'grn',
          scope_incremental = 'grc',
          node_decremental = 'grm',
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = { query = '@function.outer', desc = 'function outer' },
            ['if'] = { query = '@function.inner', desc = 'function inner' },
            ['ac'] = { query = '@class.outer', desc = 'class outer' },
            ['ic'] = { query = '@class.inner', desc = 'class inner' },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            [']s'] = { query = '@scope', query_group = 'locals', desc = 'next scope' },
            [']z'] = { query = '@fold', query_group = 'folds', desc = 'next fold' },
            [']f'] = '@function.outer',
            [']a'] = '@argument.outer',
            [']p'] = '@parameter.outer',
            [']m'] = '@method.outer',
            [']c'] = '@class.outer',
            [']d'] = '@number.inner',
          },
          goto_previous_start = {
            ['[s'] = { query = '@scope', query_group = 'locals', desc = 'previous scope' },
            ['[z'] = { query = '@fold', query_group = 'folds', desc = 'previous fold' },
            ['[f'] = '@function.outer',
            ['[a'] = '@argument.outer',
            ['[p'] = '@parameter.outer',
            ['[m'] = '@method.outer',
            ['[c'] = '@class.outer',
            ['[d'] = '@number.inner',
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
      local parsers = require('nvim-treesitter.parsers').get_parser_configs()
      parsers.report = vim.tbl_deep_extend('force', parsers.markdown, {})
    end,
  },
}

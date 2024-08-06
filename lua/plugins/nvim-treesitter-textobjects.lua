return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = { query = '@function.outer', desc = 'Function Outer' },
              ['if'] = { query = '@function.inner', desc = 'inner function' },
              ['ab'] = { query = '@block.outer', desc = 'Block Outer' },
              ['ib'] = { query = '@block.inner', desc = 'inner block' },
              ['ac'] = { query = '@class.outer', desc = 'Block Outer' },
              ['ic'] = { query = '@class.inner', desc = 'inner class' },
            },
          },
        },
      }
    end,
  },
}

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
              ['if'] = { query = '@function.inner', desc = 'Function Inner' },
              ['ab'] = { query = '@block.outer', desc = 'Block Outer' },
              ['ib'] = { query = '@block.inner', desc = 'Block Inner' },
              ['ac'] = { query = '@class.outer', desc = 'Block Outer' },
              ['ic'] = { query = '@class.inner', desc = 'Block Inner' },
            },
          },
        },
      }
    end,
  },
}

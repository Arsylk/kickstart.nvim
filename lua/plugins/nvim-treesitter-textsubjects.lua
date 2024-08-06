return {
  {
    'RRethy/nvim-treesitter-textsubjects',
    config = function()
      require('nvim-treesitter.configs').setup {
        textsubjects = {
          enable = true,
          prev_selection = ',',
          keymaps = {
            ['.'] = { 'textsubjects-smart', desc = 'Textsubject Smart' },
            [';'] = { 'textsubjects-container-outer', desc = 'outer Textsubject Container' },
            ['i;'] = { 'textsubjects-container-inner', desc = 'inner Textsubject Container' },
          },
        },
      }
    end,
  },
}

return {
  {
    'RREthy/vim-illuminate',
    config = function()
      require('illuminate').configure {
        filetypes_denylist = {
          'oil',
        },
      }
    end,
  },
}

return {
  {
    'RREthy/vim-illuminate',
    config = function()
      require('illuminate').configure {
        delay = 200,
        filetypes_denylist = {
          'oil',
        },
      }
    end,
  },
}

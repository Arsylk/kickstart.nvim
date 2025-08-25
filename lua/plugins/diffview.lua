return {
  'sindrets/diffview.nvim',
  keys = {
    {
      '<leader>do',
      '<Cmd>DiffviewOpen<CR>',
      noremap = true,
      silent = true,
      desc = 'diffview open',
    },
    {
      '<leader>dc',
      '<Cmd>DiffviewClose<CR>',
      noremap = true,
      silent = true,
      desc = 'diffview close',
    },
    {
      '<leader>df',
      '<Cmd>DiffviewFileHistory %<CR>',
      noremap = true,
      silent = true,
      desc = 'diffview file history',
    },
    {
      '<leader>dh',
      '<Cmd>DiffviewFileHistory<CR>',
      noremap = true,
      silent = true,
      desc = 'diffview history',
    },
  },
  opts = {},
}

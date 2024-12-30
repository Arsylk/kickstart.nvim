return {
  {
    'aaronik/treewalker.nvim',
    keys = {
      {
        '<C-Up>',
        '<Cmd>Treewalker Up<CR>',
        noremap = true,
        silent = true,
        desc = 'Tree walk Up',
      },
      {
        '<C-Down>',
        '<Cmd>Treewalker Down<CR>',
        noremap = true,
        silent = true,
        desc = 'Tree walk Down',
      },
      {
        '<C-Left>',
        '<Cmd>Treewalker Left<CR>',
        noremap = true,
        silent = true,
        desc = 'Tree walk Left',
      },
      {
        '<C-Right>',
        '<Cmd>Treewalker Right<CR>',
        noremap = true,
        silent = true,
        desc = 'Tree walk Right',
      },
    },
    opts = {
      highlight = true,
    },
  },
}

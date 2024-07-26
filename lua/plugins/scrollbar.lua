return {
  {
    enabled = not vim.g.vscode,
    'petertriho/nvim-scrollbar',
    opts = {
      show = true,
      marks = {
        Cursor = {
          text = '<',
        },
      },
      handlers = {
        gitsigns = true,
      },
    },
  },
}

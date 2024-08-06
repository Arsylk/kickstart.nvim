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
        cursor = false,
        search = true,
        gitsigns = true,
      },
    },
  },
}

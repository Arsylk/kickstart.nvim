return {
  {
    'petertriho/nvim-scrollbar',
    enabled = not vim.g.vscode,
    opts = function()
      require 'scrollbar'
      return {
        show = true,
        excluded_filetypes = {
          'dashboard',
          'snacks_notif',
        },
      }
    end,
  },
}

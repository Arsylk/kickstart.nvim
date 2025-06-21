return {
  {
    'lewis6991/gitsigns.nvim',
    --- @type Gitsigns.Config
    opts = {
      sign_priority = 1,
      signs = {
        add = { text = '' },
        change = { text = '' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '' },
        untracked = { text = '' },
      },
      signs_staged = {
        add = { text = '' },
        change = { text = '' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '' },
        untracked = { text = '' },
      },
      numhl = true,
    },
    config = function(_, opts)
      require('gitsigns').setup(opts)
      local ok, scrollbar = pcall(require, 'scrollbar.handlers.gitsigns')
      if ok then
        scrollbar.setup()
      end
    end,
  },
}

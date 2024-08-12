return {
  {
    'mikesmithgh/kitty-scrollback.nvim',
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
    event = { 'User KittyScrollbackLaunch' },
    config = function()
      require('kitty-scrollback').setup {
        search = {
          callbacks = {
            after_ready = function()
              vim.api.nvim_feedkeys('?', 'n', false)
            end,
          },
        },
      }
    end,
  },
}

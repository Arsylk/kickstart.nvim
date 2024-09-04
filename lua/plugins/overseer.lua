return {
  {
    'stevearc/overseer.nvim',
    opts = {
      bundles = {
        autostart_on_load = false,
      },
      strategy = {
        'toggleterm',
        open_on_start = false,
        close_on_exit = false,
        quit_on_exit = 'never',
        direction = 'horizontal',
      },
    },
  },
}

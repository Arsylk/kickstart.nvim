return {
  {
    'stevearc/overseer.nvim',
    opts = {
      bundles = {
        save_task_opts = {
          bundleable = true,
        },
        autostart_on_load = false,
      },
      strategy = {
        'toggleterm',
        open_on_start = false,
        close_on_exit = false,
      },
    },
  },
}

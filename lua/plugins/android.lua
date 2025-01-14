return {
  {
    'Arsylk/android.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    opts = {
      commands = {
        avdmanager = 'avdmanager',
        emulator = {
          cmd = 'emulator-init',
          args = {
            '{}',
          },
        },
      },
    },
  },
}

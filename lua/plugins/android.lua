return {
  {
    'Arsylk/android.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    opts = {
      commands = {
        avdmanager = vim.fn.expand '~/Library/Android/sdk/cmdline-tools/latest/bin/avdmanager',
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

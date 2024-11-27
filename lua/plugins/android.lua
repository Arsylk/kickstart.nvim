return {
  {
    'Arsylk/android.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    opts = {
      commands = {
        avdmanager = '/opt/android-sdk/cmdline-tools/latest/bin/avdmanager',
        emulator = {
          cmd = '/opt/android-sdk/emulator/emulator',
          args = {
            '-avd',
            '{}',
          },
        },
      },
    },
  },
}

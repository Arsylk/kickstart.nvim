return {
  {
    'mfussenegger/nvim-jdtls',
    enabled = false,
    dependencies = { 'mfussenegger/nvim-dap' },
    ft = { 'java' },
    config = function()
      local extendedClientCapabilities = require('jdtls').extendedClientCapabilities or {}
      extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      local root_dir = require('jdtls.setup').find_root { 'gradlew', '.git' }
      local workspace = vim.fs.joinpath(root_dir, '.jdtls')
      local config = {
        cmd = {
          '/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home/bin/java',
          '-Declipse.application=org.eclipse.jdt.ls.core.id1',
          '-Dosgi.bundles.defaultStartLevel=4',
          '-Declipse.product=org.eclipse.jdt.ls.core.product',
          '-Dlog.protocol=true',
          '-Dlog.level=ALL',
          '-Xmx4g',
          '--add-modules=ALL-SYSTEM',
          '--add-opens',
          'java.base/java.util=ALL-UNNAMED',
          '--add-opens',
          'java.base/java.lang=ALL-UNNAMED',
          '-jar',
          vim.fn.expand '~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher.cocoa.macosx.aarch64_1.2.1100.v20240722-2106.jar',
          '-configuration',
          vim.fn.expand '~/.local/share/nvim/mason/packages/jdtls/config_mac_arm',
          '-data',
          workspace,
        },
        root_dir = root_dir,
        settings = {
          java = {
            configuration = {
              runtimes = {
                {
                  name = 'JavaSE-17',
                  path = ' /opt/homebrew/opt/openjdk@17/',
                },
                {
                  name = 'JavaSE-21',
                  path = ' /opt/homebrew/opt/openjdk@21/',
                },
                {
                  name = 'JavaSE-23',
                  path = ' /opt/homebrew/opt/openjdk@23/',
                },
              },
            },
          },
        },
        init_options = {
          bundles = {},
          extendedClientCapabilities = extendedClientCapabilities,
        },
      }
      require('jdtls').start_or_attach(config)
    end,
  },
}

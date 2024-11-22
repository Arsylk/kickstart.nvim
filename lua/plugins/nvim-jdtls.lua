return {
  {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    config = function()
      local INSTALL_DIR = '/opt/github/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository'
      local project = require('jdtls.setup').find_root { '.git', 'gradlew', 'pom.xml', 'mvnw' }
      local workspace = vim.fs.joinpath(project, '.jdtls')
      local config = {
        cmd = {
          INSTALL_DIR .. '/bin/jdtls',
          -- ---- java binary path
          -- '/usr/lib/jvm/java-21-jetbrains/bin/java',
          -- ---- jdtls arguments
          -- '-Declipse.application=org.eclipse.jdt.ls.core.id1',
          -- '-Dosgi.bundles.defaultStartLevel=4',
          -- '-Declipse.product=org.eclipse.jdt.ls.core.product',
          -- '-Dlog.protocol=true',
          -- '-Dlog.level=ALL',
          -- '-Xmx1g',
          -- '--add-modules=ALL-SYSTEM',
          -- '--add-opens',
          -- 'java.base/java.util=ALL-UNNAMED',
          -- '--add-opens',
          -- 'java.base/java.lang=ALL-UNNAMED',
          -- --- jdtls jar path
          -- '-jar',
          -- INSTALL_DIR .. '/plugins/org.eclipse.equinox.app_1.7.200.v20240722-2103.jar',
          -- --- jdtls configuration file
          -- '-configuration',
          -- INSTALL_DIR .. '/config_linux/config.ini',
          --- unique per project jdtls workspace
          '--data',
          workspace,
        },
        root_dir = project,
        setting = {
          java = {
            references = {
              includeDecompiledSources = true,
            },
          },
        },
        on_attach = function(_, bufnr)
          local jdtls = require 'jdtls'
          jdtls.setup_dap { hotcodereplace = 'auto' }
          local jdtls_dap = require 'jdtls.dap'
          jdtls_dap.setup_dap_main_class_configs()
          jdtls_dap.add_commands()
        end,
        capabilities = {
          workspace = {
            configuration = true,
          },
          textDocument = {
            completion = {
              completionItem = {
                snippetSupport = true,
              },
            },
          },
        },
        on_init = function(client, _)
          client.notify('workspace/didChangeConfiguration', { settings = { flags = { allow_incremental_sync = true } } })
        end,
        init_options = {
          extendedClientCapabilities = require('jdtls').extendedClientCapabilities,
        },
      }
      require('jdtls').start_or_attach(config)
    end,
  },
}

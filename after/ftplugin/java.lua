vim.cmd [[ setlocal et sw=4 ]]

-- local jdtls = require 'jdtls'
-- local jdtls_dap = require 'jdtls.dap'
-- local root_markers = { 'gradlew', '.git' }
-- local root_dir = require('jdtls.setup').find_root(root_markers)
-- local home = os.getenv 'HOME'
-- local workspace = vim.fs.joinpath(root_dir, '.jdtls')
-- local config = { handlers = {} }
-- config.settings = {
--   java = {
--     signatureHelp = { enabled = true },
--     contentProvider = { preferred = 'fernflower' },
--     completion = {
--       favoriteStaticMembers = {
--         'org.hamcrest.MatcherAssert.assertThat',
--         'org.hamcrest.Matchers.*',
--         'org.hamcrest.CoreMatchers.*',
--         'org.junit.jupiter.api.Assertions.*',
--         'java.util.Objects.requireNonNull',
--         'java.util.Objects.requireNonNullElse',
--         'org.mockito.Mockito.*',
--       },
--       filteredTypes = {
--         'com.sun.*',
--         'io.micrometer.shaded.*',
--         'java.awt.*',
--         'jdk.*',
--         'sun.*',
--       },
--     },
--     sources = {
--       organizeImports = {
--         starThreshold = 9999,
--         staticStarThreshold = 9999,
--       },
--     },
--     codeGeneration = {
--       toString = {
--         template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
--       },
--       hashCodeEquals = {
--         useJava7Objects = true,
--       },
--       useBlocks = true,
--     },
--     configuration = {
--       runtimes = {
--         {
--           name = 'JavaSE-17',
--           path = ' /opt/homebrew/opt/openjdk@17/',
--         },
--         {
--           name = 'JavaSE-21',
--           path = ' /opt/homebrew/opt/openjdk@21/',
--         },
--         {
--           name = 'JavaSE-23',
--           path = ' /opt/homebrew/opt/openjdk@23/',
--         },
--       },
--     },
--   },
-- }
-- config.cmd = {
--   '/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home/bin/java',
--   '-Declipse.application=org.eclipse.jdt.ls.core.id1',
--   '-Dosgi.bundles.defaultStartLevel=4',
--   '-Declipse.product=org.eclipse.jdt.ls.core.product',
--   '-Dlog.protocol=true',
--   '-Dlog.level=ALL',
--   '-Xmx4g',
--   '--add-modules=ALL-SYSTEM',
--   '--add-opens',
--   'java.base/java.util=ALL-UNNAMED',
--   '--add-opens',
--   'java.base/java.lang=ALL-UNNAMED',
--   '-jar',
--   vim.fn.expand '~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher.cocoa.macosx.aarch64_1.2.1100.v20240722-2106.jar',
--   '-configuration',
--   vim.fn.expand '~/.local/share/nvim/mason/packages/jdtls/config_mac',
--   '-data',
--   workspace,
-- }
-- config.on_attach = function(client, bufnr)
--   jdtls.setup_dap { hotcodereplace = 'auto' }
--   jdtls_dap.setup_dap_main_class_configs()
--   jdtls.setup.add_commands()
--   local opts = { silent = true, buffer = bufnr }
--   vim.keymap.set('n', '<A-o>', jdtls.organize_imports, opts)
--   vim.keymap.set('n', '<leader>df', jdtls.test_class, opts)
--   vim.keymap.set('n', '<leader>dn', jdtls.test_nearest_method, opts)
--   vim.keymap.set('n', 'crv', jdtls.extract_variable, opts)
--   vim.keymap.set('v', 'crm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
--   vim.keymap.set('n', 'crc', jdtls.extract_constant, opts)
-- end
--
-- local extendedClientCapabilities = jdtls.extendedClientCapabilities
-- extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
-- config.init_options = {
--   bundles = {},
--   extendedClientCapabilities = extendedClientCapabilities,
-- }
-- -- mute; having progress reports is enough
-- config.handlers['language/status'] = function() end
-- jdtls.start_or_attach(config)

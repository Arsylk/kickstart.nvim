return {
  {
    'native-lsp-config',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'folke/lazydev.nvim',
      'b0o/schemastore.nvim',
      'saghen/blink.cmp',
      'j-hui/fidget.nvim',
      'folke/lazydev.nvim',
    },
    dir = vim.fn.stdpath 'config',
    config = function()
      require('lspconfig.ui.windows').default_options.border = 'rounded'

      require('lazydev').setup {}

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.callHierarchy.dynamicRegistration = true

      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostic = {
              globals = { 'vim' },
            },
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
                vim.fn.stdpath 'config',
                '${3rd}/luv/library',
              },
            },
          },
        },
      })

      vim.lsp.config('biome', {
        capabilities = capabilities,
        cmd = { 'biome', 'lsp-proxy' },
        filetypes = { 'javascript', 'javascriptreact', 'json', 'jsonc', 'typescript', 'typescriptreact', 'astro', 'svelte', 'vue' },
        root_markers = { 'biome.json', 'biome.jsonc', 'package.json', 'node_modules', '.git' },
        single_file_support = true,
        settings = {
          biome = {
            single_file_support = true,
          },
        },
      })

      vim.lsp.config('ts_ls', {
        capabilities = capabilities,
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
      })

      vim.lsp.config('jsonls', {
        capabilities = capabilities,
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = { 'json', 'jsonc' },
        root_markers = { 'package.json', '.git' },
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = {
              enable = true,
            },
          },
        },
      })

      vim.lsp.config('yamlls', {
        capabilities = capabilities,
        cmd = { 'yaml-language-server', '--stdio' },
        filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
        root_markers = { '.git' },
        settings = {
          yaml = {
            schemas = require('schemastore').yaml.schemas(),
          },
          schemaStore = {
            enable = true,
          },
        },
      })

      vim.lsp.config('pylsp', {
        capabilities = capabilities,
        cmd = { 'pylsp' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
        settings = {
          pylsp = {
            plugins = {
              -- Code style and formatting
              pycodestyle = { enabled = false }, -- Disable in favor of ruff
              pydocstyle = { enabled = false }, -- Disable in favor of ruff
              pyflakes = { enabled = false }, -- Disable in favor of ruff
              mccabe = { enabled = false }, -- Disable in favor of ruff

              -- Enable useful plugins
              pylsp_mypy = {
                enabled = true,
                live_mode = false,
                strict = false,
              },
              rope_autoimport = { enabled = true },
              rope_completion = { enabled = true },

              -- Refactoring
              rope = { enabled = true },

              -- Code completion
              jedi_completion = {
                enabled = true,
                include_params = true,
                include_class_objects = true,
                fuzzy = true,
              },
              jedi_hover = { enabled = true },
              jedi_references = { enabled = true },
              jedi_signature_help = { enabled = true },
              jedi_symbols = { enabled = true },
            },
          },
        },
      })

      vim.lsp.config('ruff', {
        cmd = { 'ruff', 'server' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
        init_options = {
          settings = {
            -- Ruff configuration
            args = {
              '--config',
              'pyproject.toml',
            },
            logLevel = 'info',
          },
        },
      })

      vim.lsp.config('basedpyright', {
        cmd = { 'basedpyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = { 'pyrightconfig.json', 'pyproject.toml', 'setup.py', '.git' },
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = 'basic',
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              autoImportCompletions = true,
              diagnosticMode = 'workspace',
            },
          },
        },
      })

      vim.lsp.enable { 'biome', 'ts_ls', 'lua_ls', 'jsonls', 'yamlls', 'basedpyright', 'ruff' }

      -- kotlin_language_server = {
      --   settings = {
      --     kotlin_language_server = (function()
      --       local root_files = {
      --         'settings.gradle',
      --         'settings.gradle.kts',
      --         'build.xml',
      --         'pom.xml',
      --         'build.gradle',
      --         'build.gradle.kts',
      --       }
      --       local util = require 'lspconfig.util'
      --       return {
      --         version = '1.3.12',
      --         filetypes = { 'kotlin', 'kts' },
      --         cmd = { 'kotlin-language-server' },
      --         root_dir = util.root_pattern(unpack(root_files)),
      --       }
      --     end)(),
      --   },
      -- },
    end,
  },
}

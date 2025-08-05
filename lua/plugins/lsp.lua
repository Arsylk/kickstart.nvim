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
      capabilities.textDocument.completion.completionItem = {
        documentationFormat = { 'markdown', 'plaintext' },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
          properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
          },
        },
      }
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

      -- Python LSP Configuration for Ghidra Development
      vim.lsp.config('pylsp', {
        capabilities = capabilities,
        cmd = { 'pylsp' },
        filetypes = { 'python' },
        root_markers = {
          'ghidra_scripts',
          'data/scripts',
          '.ghidra',
          'pyproject.toml',
          'setup.py',
          'requirements.txt',
          '.git',
        },
      })

      vim.lsp.config('basedpyright', {
        capabilities = capabilities,
        cmd = { 'basedpyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = {
          'ghidra_scripts',
          'data/scripts',
          '.ghidra',
          'pyproject.toml',
          'setup.py',
          'requirements.txt',
          '.git',
        },
        settings = {
          python = {
            pythonPath = '.venv/bin/python',
          },
        },
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'java' },
        desc = 'Auto trigger java lsp',
        callback = function(params)
          vim.schedule(function()
            require('java').setup()
            vim.lsp.config('jdtls', {
              settings = {
                java = {
                  configuration = {
                    runtimes = {
                      {
                        name = 'Java-24',
                        path = '/opt/homebrew/Cellar/openjdk/24.0.1/libexec/openjdk.jdk/Contents/Home',
                        default = true,
                      },
                    },
                  },
                },
              },
            })
          end)
        end,
      })

      vim.lsp.enable { 'biome', 'ts_ls', 'lua_ls', 'jsonls', 'yamlls', 'pylsp', 'basedpyright', 'jdtls' }

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

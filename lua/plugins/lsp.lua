return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'folke/lazydev.nvim',
      'b0o/schemastore.nvim',
      'saghen/blink.cmp',
      'j-hui/fidget.nvim',
    },
    config = function()
      require('lazydev').setup {}
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.callHierarchy.dynamicRegistration = true

      local servers = {
        biome = {
          settings = {
            biome = {
              single_file_support = true,
            },
          },
        },
        ts_ls = {},
        lua_ls = {
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
        },
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = {
                enable = true,
              },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemas = require('schemastore').yaml.schemas(),
            },
            schemaStore = {
              enable = true,
            },
          },
        },
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = { enabled = false },
              },
            },
          },
        },
        ruff = {
          settings = {
            init_options = {},
          },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              hints = {
                assignVariableTypes = true,
              },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
        jsonls = {
          cmd = 'nya',
          settings = {
            jsonls = {},
            java = {
              import = {
                gradle = {
                  enabled = true,
                },
                maven = {
                  enabled = true,
                },
                exclusions = {
                  '**/node_modules/**',
                  '**/.metadata/**',
                  '**/archetype-resources/**',
                  '**/META-INF/maven/**',
                  '/**/test/**',
                },
              },
            },
          },
        },
        kotlin_language_server = {
          settings = {
            kotlin_language_server = (function()
              local root_files = {
                'settings.gradle',
                'settings.gradle.kts',
                'build.xml',
                'pom.xml',
                'build.gradle',
                'build.gradle.kts',
              }
              local util = require 'lspconfig.util'
              return {
                version = '1.3.12',
                filetypes = { 'kotlin', 'kts' },
                cmd = { 'kotlin-language-server' },
                root_dir = util.root_pattern(unpack(root_files)),
              }
            end)(),
          },
        },
      }

      require('lspconfig.ui.windows').default_options.border = 'rounded'

      --  You can press `g?` for help in this menu.
      require('mason').setup { ui = { border = 'rounded' } }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, { 'stylua', 'shfmt' })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}

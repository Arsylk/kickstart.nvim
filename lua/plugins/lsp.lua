return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'folke/lazydev.nvim',
      'b0o/schemastore.nvim',
      { 'j-hui/fidget.nvim' },
    },
    config = function()
      require('lazydev').setup {}
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
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
        tsserver = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = {
                disable = { 'missing-fields' },
                globals = { 'vim' },
              },
              runtime = {
                path = { '?.lua', '?/init.lua' },
                pathStrict = true,
                version = 'LuaJIT',
              },
              workspace = {
                checkThirdParty = false,
                ignoreDir = { '/lua' },
                library = {
                  '/usr/share/nvim/runtime',
                  '/home/arsylk/.local/share/nvim/lazy/lazy.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/cmp-nvim-lsp',
                  '/home/arsylk/.local/share/nvim/lazy/fidget.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/schemastore.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/lazydev.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/mason-tool-installer.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/mason-lspconfig.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/mason.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/nvim-lspconfig',
                  '/home/arsylk/.local/share/nvim/lazy/nvim-treesitter',
                  '/home/arsylk/.local/share/nvim/lazy/rainbow-delimiters.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/undotree',
                  '/home/arsylk/.local/share/nvim/lazy/gitsigns.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/lualine-lsp-progress',
                  '/home/arsylk/.local/share/nvim/lazy/lualine.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/tabline.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/yanky.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/nvim-notify',
                  '/home/arsylk/.local/share/nvim/lazy/nui.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/noice.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/nvim-web-devicons',
                  '/home/arsylk/.local/share/nvim/lazy/telescope-undo.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/telescope-ui-select.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/telescope-fzf-native.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/telescope.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/diffview.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/plenary.nvim',
                  '/home/arsylk/.local/share/nvim/lazy/neogit',
                  '/home/arsylk/.local/share/nvim/lazy/nvim-lint',
                  '/home/arsylk/.local/share/nvim/lazy/catppuccin',
                  '/usr/share/nvim/runtime',
                  '/usr/lib/nvim',
                  '/home/arsylk/.local/share/nvim/lazy/cmp-nvim-lsp/after',
                  '/home/arsylk/.local/share/nvim/lazy/catppuccin/after',
                  '/home/arsylk/.config/nvim/after',
                  '/home/arsylk/.local/state/nvim/lazy/readme',
                  '/usr/share/nvim/runtime/lua',
                  '/home/arsylk.local/share/nvim/lazy/luvit-meta/library',
                  '/home/arsylk/.config/nvim/lua',
                  '/home/arsylk/.local/share/nvim/lazy/noice.nvim/lua',
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
                pycodestyle = {
                  ignore = { 'W391' },
                  maxLineLength = 120,
                },
              },
            },
          },
        },
        hyprls = {
          settings = {
            hyprls = {},
          },
        },
      }

      --  You can press `g?` for help in this menu.
      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, { 'stylua' })
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

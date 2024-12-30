return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = function()
      --- @type snacks.Config
      return {
        bigfile = { enabled = true },
        notifier = {
          enabled = true,
          style = 'compact',
          width = {
            min = 32,
          },
          date_format = '%I:%M %p',
        },
        quickfile = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = {
          enabled = true,
          left = { 'git', 'fold' },
          right = { 'sign', 'mark' },
          folds = {
            open = true,
            git_hl = true,
          },
          git = {
            patterns = { 'GitSigns' },
          },
        },
        words = { enabled = false },
        toggle = {
          enabled = true,
          map = vim.keymap.set,
          which_key = true,
          notify = true,
          icon = {
            enabled = '󰨚',
            disabled = '󰨙',
          },
          color = {
            enabled = 'blue',
            disabled = 'black',
          },
        },
      }
    end,
    init = function()
      require 'snacks'
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          _G.log = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.log

          -- enable notifier
          Snacks.notifier.health()

          -- create basic toggle mappings
          Snacks.toggle.option('background', { name = 'Dark Background', on = 'dark', off = 'light' }):map '<leader>tb'
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>tw'
          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>trn'
          Snacks.toggle.diagnostics():map '<leader>td'
          Snacks.toggle.line_number():map '<leader>tln'
          Snacks.toggle.treesitter():map '<leader>tt'
          Snacks.toggle.inlay_hints():map '<leader>tih'
        end,
      })

      ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
      local progress = vim.defaulttable()
      vim.api.nvim_create_autocmd('LspProgress', {
        ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
          if not client or type(value) ~= 'table' then
            return
          end
          local p = progress[client.id]

          for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
              p[i] = {
                token = ev.data.params.token,
                msg = ('[%3d%%] %s%s'):format(
                  value.kind == 'end' and 100 or value.percentage or 100,
                  value.title or '',
                  value.message and (' **%s**'):format(value.message) or ''
                ),
                done = value.kind == 'end',
              }
              break
            end
          end

          local msg = {} ---@type string[]
          progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
          end, p)

          local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
          vim.notify(table.concat(msg, '\n'), 'info', {
            id = 'lsp_progress',
            title = client.name,
            opts = function(notif)
              notif.icon = #progress[client.id] == 0 and ' ' or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end,
      })
    end,
  },
}

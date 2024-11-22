return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<A-f>',
        function()
          local conform = require 'conform'
          local notify = require 'notify'
          local fmt = conform.list_formatters_for_buffer(0)[1]

          if vim.api.nvim_buf_get_var(0, 'autoformat') == false then
            notify.notify("Skipping 'noautoformat' file ...", vim.log.levels.DEBUG, { replace = record })
            return
          end

          local msg = ('Running %s on %s'):format(fmt, vim.api.nvim_buf_get_name(0))
          local record = notify.notify(msg, vim.log.levels.INFO, {})
          conform.format({ async = true, lsp_fallback = true }, function(err, did_edit)
            if err then
              notify.notify(('Error from %s'):format(fmt), vim.log.levels.ERROR, { replace = record })
            elseif did_edit then
              notify.notify('File formatted successfully', vim.log.levels.INFO, { replace = record })
            else
              notify.notify('File is already formatted', vim.log.levels.INFO, { replace = record })
            end
          end)
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = true,
      formatters_by_ft = {
        ['_'] = { 'trim_whitespace' },
        lua = { 'stylua' },
        javascript = { 'biome' },
        typescript = { 'biome' },
        json = { 'biome' },
        sh = { 'fmtsh' },
        fish = { 'fish_indent' },
        bash = { 'fmtsh' },
        python = { 'ruff_format' },
        caddyfile = { 'caddyfile' },
      },
      formatters = {
        caddyfile = {
          command = 'caddy',
          args = { 'fmt', '-' },
          stdin = true,
        },
      },
      format_on_save = function(bufnr)
        local disable_filetypes = {
          --[[  c = true, cpp = true  ]]
        }
        return {
          timeout_ms = 2000,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
    },
  },
}

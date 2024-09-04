return {
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<A-f>',
        function()
          local fmt = require('conform').list_formatters_for_buffer(0)[1]
          local msg = ('Running %s on %s'):format(fmt, vim.api.nvim_buf_get_name(0))

          local record = require('notify').notify(msg, vim.log.levels.INFO, {})
          require('conform').format({ async = true, lsp_fallback = true }, function(err, did_edit)
            if err then
              require('notify').notify(('Error from %s'):format(fmt), vim.log.levels.ERROR, { replace = record })
            elseif did_edit then
              require('notify').notify('File formatted successfully', vim.log.levels.INFO, { replace = record })
            else
              require('notify').notify('File is already formatted', vim.log.levels.INFO, { replace = record })
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
        python = { 'ruff_format' },
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

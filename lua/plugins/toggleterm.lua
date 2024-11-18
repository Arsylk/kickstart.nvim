return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    init = function()
      vim.api.nvim_create_autocmd('BufWinEnter', {
        desc = 'Detect terminal & disable line highlight',
        pattern = 'term://*',
        callback = function(params)
          local winnr = vim.fn.bufwinid(params.buf)
          vim.api.nvim_set_option_value('cursorline', false, { win = winnr })
        end,
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'toggleterm' },
        callback = function(params)
          vim.keymap.set('n', 'cd', function()
            local winnr = vim.fn.bufwinid(params.buf)
            local lastwin = nil
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              if win ~= winnr then
                lastwin = win
              end
            end
            if not lastwin then
              return
            end
            local lastfile = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(lastwin))
            if not lastfile or lastfile == '' then
              return
            end
            local folder = vim.fn.fnamemodify(lastfile, ':h'):gsub('^.-://', '')
            local term = require('toggleterm.terminal').find(function(term)
              return (term.bufnr == params.buf)
            end)
            if not folder or not term then
              return
            end
            term:change_dir(folder)
          end, { noremap = true, buffer = params.buf, desc = 'Open directory of last file' })
        end,
      })
    end,
    opts = {
      size = 24,
      open_mapping = [[<c-t>]],
    },
  },
}

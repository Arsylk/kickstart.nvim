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
    end,
    opts = {
      size = 24,
      open_mapping = [[<c-t>]],
    },
  },
}

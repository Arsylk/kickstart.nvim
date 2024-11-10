return {
  {
    'willothy/flatten.nvim',
    priority = 1001,
    lazy = false,
    opts = function()
      local term
      return {
        window = {
          open = 'alternate',
        },
        callbacks = {
          should_block = function(argv)
            return vim.tbl_contains(argv, '-b')
          end,
          pre_open = function()
            local toggleterm = require 'toggleterm.terminal'
            local termid = toggleterm.get_focused_id()
            term = toggleterm.get(termid)
          end,
          post_open = function(bufnr, winnr, ft, is_blocking)
            if is_blocking and term then
              term:close()
            else
              vim.api.nvim_set_current_win(winnr)
            end
          end,
          block_end = function()
            if term then
              term:open()
              term = nil
            end
          end,
        },
      }
    end,
  },
}

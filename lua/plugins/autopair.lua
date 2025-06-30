return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      check_ts = true,
      enable_check_bracket_line = true,
      map_cr = true,
    },
    config = function(_, opts)
      require('nvim-autopairs').setup(opts)
    end,
  },
}

return {
  {
    'bbjornstad/pretty-fold.nvim',
    opts = {
      fill_char = ' ',
      sections = {
        left = { 'content' },
        right = { 'number_of_folded_lines' },
      },
      matchup_patterns = {
        { '{', '}' },
        { '%(', ')' }, -- % to escape lua pattern char
        { '%[', ']' }, -- % to escape lua pattern char
      },
    },
    config = function(_, opts)
      require('pretty-fold').setup(opts)
      require('pretty-fold').ft_setup('lua', {
        matchup_patterns = {
          { '^%s*do$', 'end' }, -- do ... end blocks
          { '^%s*if', 'end' }, -- if ... end
          { '^%s*for', 'end' }, -- for
          { '^%s*while', 'end' }, -- while
          { 'function%s*%(', 'end' }, -- 'function( or 'function (''
          { '{', '}' },
          { '%(', ')' }, -- % to escape lua pattern char
          { '%[', ']' }, -- % to escape lua pattern char
        },
      })
    end,
  },
}

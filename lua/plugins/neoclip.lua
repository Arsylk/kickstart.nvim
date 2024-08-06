local function is_whitespace(line)
  return vim.fn.match(line, [[^\s*$]]) ~= -1
end

local function all(tbl, check)
  for _, entry in ipairs(tbl) do
    if not check(entry) then
      return false
    end
  end
  return true
end

return {
  {
    'AckslD/nvim-neoclip.lua',
    dependencies = {
      'ibhagwan/fzf-lua',
    },
    config = function()
      require('neoclip').setup {
        preview = true,
        content_spec_column = true,
        filter = function(data)
          return not all(data.event.regcontents, is_whitespace)
        end,
      }
    end,
  },
}

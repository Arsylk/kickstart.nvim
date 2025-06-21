--- @param lines string[] | string
--- @return {pkg: string, ver: number, id: string} | nil
local function get_metadata(lines)
  if type(lines) ~= 'table' then
    lines = { lines }
  end

  local pattern = '^#### %[([%w%._]+) %(Version (%d+)%)%]'
  for _, line in pairs(lines) do
    local pkg, ver = string.match(line, pattern)
    if pkg and ver then
      local id = string.match(line, '[?&]marmot_id=([%d:]+)')
      return { pkg = pkg, ver = tonumber(ver), id = id }
    end
  end
  return nil
end

--- @param meta {pkg: string, ver: number}
--- @return string
local function get_auto_path(meta)
  local fname = vim.fn.strftime 'report_%d-%m-%Y.md'
  local fdir = string.format('%s-%d', meta.pkg, meta.ver)
  return vim.fs.joinpath('~/Workspace/', fdir, fname)
end

local cb = function(args)
  local buf = vim.api.nvim_get_current_buf()
  local groupId = vim.api.nvim_create_augroup('ReportWorkspaceCmds', { clear = true })
end

local arpId = vim.api.nvim_create_augroup('ReportFiletypeGroup', { clear = true })
vim.filetype.add {
  filename = {
    ['report.md'] = 'report',
  },
  pattern = {
    ['.*/report.*%.md'] = 'report',
  },
}
-- vim.cmd [[ filetype plugin add report,markdown ]]
vim.treesitter.language.register('markdown', 'report')
vim.api.nvim_create_autocmd('FileType', {
  group = arpId,
  pattern = { 'report' },
  callback = function(args)
    --- begin scoped functions
    local buf = args.buf

    vim.api.nvim_buf_set_keymap(buf, 'n', 'yr', '', {
      callback = function()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local meta = get_metadata(lines)
        if meta then
          local message = string.format('`%s` ver *%d*', meta.pkg, meta.ver)
          vim.notify(message, vim.log.levels.INFO, {
            id = 'report-yank-id',
            title = meta.id,
          })
          local formatted = string.format('%s\t%s', meta.id, meta.pkg)
          vim.api.nvim_call_function('setreg', { '+', { formatted } })
        end
      end,
    })
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = buf,
      callback = function()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local meta = get_metadata(lines)
        if meta then
          local alt = get_auto_path(meta)
          vim.fn.mkdir(vim.fs.dirname(alt), 'p')
          vim.cmd(string.format('w! %s', alt))
        end
      end,
    })
  end,
})

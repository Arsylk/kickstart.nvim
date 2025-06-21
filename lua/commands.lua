-- Quick inspect lua objects
vim.cmd [[:command! -nargs=1 I lua inspectFn(<f-args>)]]
function inspectFn(obj)
  local cmd = string.format('lua print(vim.inspect(%s))', obj)
  require('noice').redirect(cmd, { view = 'hsplit', filter = {
    cond = function(_)
      return true
    end,
  } })
end

-- Redirect command output into new buffer
vim.api.nvim_create_user_command('Redir', function(ctx)
  local exec = vim.api.nvim_exec2(ctx.args, { output = true })
  local lines = vim.split(exec.output, '\n', { plain = true })
  vim.cmd [[new]]
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
end, { nargs = '+', complete = 'command' })

-- Conform pretty format command
vim.api.nvim_create_user_command('ConformFormat', function(args)
  local fmt = require('conform').list_formatters_for_buffer(0)[1]
  local msg = string.format('Running %s on %s', fmt, vim.api.nvim_buf_get_name(0))

  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ['end'] = { args.line2, end_line:len() },
    }
  end

  vim.notify(msg, vim.log.levels.INFO, {})
  require('conform').format({ async = true, lsp_fallback = true, range = range, formatters = { fmt } }, function(err, did_edit)
    if err then
      vim.notify(('Error from %s'):format(fmt), vim.log.levels.ERROR, {})
    elseif did_edit then
      vim.notify('File formatted successfully', vim.log.levels.INFO, {})
    else
      vim.notify('File is already formatted', vim.log.levels.INFO, {})
    end
  end)
end, {
  desc = 'Format current buffer with Conform',
  range = true,
  nargs = '?',
  complete = function()
    return vim.tbl_map(function(x)
      return x.name
    end, require('conform').list_all_formatters())
  end,
})

-- Perform live(ish) command operations
vim.api.nvim_create_user_command('Playdict', function(ctx)
  local output = vim.api.nvim_exec(ctx.args, true)
  local bufs = vim.fn.tabpagebuflist()
  local selfbuf = vim.api.nvim_get_current_buf()
  for i = 1, #bufs, 1 do
    if selfbuf ~= bufs[i] then
      local lines = vim.split(output, '\n', { plain = true })
      vim.api.nvim_buf_set_lines(bufs[i], 0, -1, false, lines)
      break
    end
  end
end, { bang = true, nargs = '+', complete = 'command' })

-- Gpg easy decrypt message
vim.api.nvim_create_user_command('GpgDecrypt', function()
  local logfile = '/tmp/nvim-gpg.log'
  local output = vim.fn.system('gpg -o- -d ' .. vim.fn.expand '%:p:S' .. ' 2>' .. logfile)
  local loglines = vim.fn.readfile(logfile)
  local log = vim.fn.join(loglines, '\n')
  if vim.v.shell_error == 0 then
    local lines = vim.split(output, '\n', { plain = true })
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.notify(log, vim.log.levels.INFO)
  else
    vim.notify(log, vim.log.levels.ERROR)
  end
end, { nargs = 0 })

vim.api.nvim_create_user_command('GpgEncrypt', function()
  require('fzf-lua').fzf_exec(function(fzf_cb)
    coroutine.wrap(function()
      local co = coroutine.running()
      local output = vim.fn.system 'gpg --list-public-keys --list-only --keyid-format long'
      local lines = vim.split(output, '\n', { plain = true })

      local type, id
      local isOpen = false
      for _, line in ipairs(lines) do
        if line:match '^pub' and not isOpen then
          -- Extract the type and hash
          type = line:match '^pub%s+(%w+)'
          isOpen = true
        elseif line:match '^%s+' then
          -- Format the ID with spaces every 4 characters
          id = line:gsub('%S+', function(s)
            return s:gsub('(%x%x%x%x)', '%1 '):sub(1, -2)
          end)
          id = id:gsub('^%s*(.-)%s*$', '%1')
        elseif line:match '^uid' and isOpen then
          -- Match the uid line to extract name and email
          local name, email = line:match '^uid%s+%[.-%]%s+(.-)%s+<(.+)>$'
          if name and email then
            local msg = string.format('%s:', email)
            msg = msg .. string.format('[\27[34m%s\27[0m] ', type)
            msg = msg .. string.format('\27[32m%s\27[0m - %s ', email, name)
            -- msg = msg .. string.format("\27[31m%s\27[0m", id)

            fzf_cb(msg, function()
              coroutine.resume(co)
            end)
            isOpen = false
          end
        end
      end
      fzf_cb()
    end)()
  end, {
    fzf_opts = {
      ['--exact'] = '',
      ['--multi'] = '',
      ['--with-nth'] = '2..',
      ['--delimiter'] = ':',
    },
    preview = 'gpg --list-keys {1} && gpg --export --armor {1}',
    actions = {
      ['default'] = function(selected)
        local target = vim.fn.join(vim.tbl_map(function(item)
          return '-r ' .. item:match '^(.-):'
        end, selected))
        local cmd = string.format('gpg %s --armor -o- --encrypt', target)

        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

        local buffer = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_set_option_value('filetype', 'gpgcrypt', { buf = buffer })
        vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)

        vim.cmd [[65vsplit]]
        vim.api.nvim_set_current_buf(buffer)
        vim.cmd('%!' .. cmd)

        local win = vim.api.nvim_get_current_win()
        vim.api.nvim_set_option_value('number', false, { win = win })
        vim.api.nvim_set_option_value('relativenumber', false, { win = win })
        vim.api.nvim_set_option_value('signcolumn', 'no', { win = win })
        vim.api.nvim_set_option_value('cursorline', false, { win = win })
        vim.api.nvim_set_option_value('foldcolumn', '0', { win = win })
      end,
    },
  })
end, { nargs = 0 })

-- Overseer restart last task
vim.api.nvim_create_user_command('OverseerRestartLast', function()
  local overseer = require 'overseer'
  local tasks = overseer.list_tasks { recent_first = true }
  if vim.tbl_isempty(tasks) then
    vim.notify('No tasks found', vim.log.levels.WARN)
  else
    overseer.run_action(tasks[1], 'restart')
  end
end, {})

-- fzf pick android package
vim.api.nvim_create_user_command('FzfLuaAndroidPkg', function()
  local fzf = require 'fzf-lua'
  local utils = require 'fzf-lua.utils'

  local cmd = [[adb shell pm list packages -3 -f -U | sort -g -t ':' -k3]]
  local contents = function(fzf_cb)
    coroutine.wrap(function()
      local co = coroutine.running()

      vim.schedule(function()
        local processline = function(line)
          local path, pkg, uid = line:match '^package:(.-)=([%w%.%-]+)%s+uid:(%d+)$'
          local entry = string.format('%s|%s uid:%s\n%s', path, pkg, uid, utils.ansi_from_hl('Comment', path))
          return entry
        end

        local output = vim.fn.system(cmd)
        local lines = vim.split(output, '\n', { plain = true })
        table.remove(lines)
        for _, line in pairs(lines) do
          local entry = processline(line)
          fzf_cb(entry, function()
            coroutine.resume(co)
          end)
        end
      end)

      coroutine.yield()
      fzf_cb()
    end)()
  end
  fzf.fzf_exec(contents, {
    multiline = 2,
    fzf_opts = {
      ['--prompt'] = 'Package> ',
      ['--delimiter'] = '\\|',
      ['--with-nth'] = '2..',
    },
    preview = 'adb shell run-as com.termux "/data/data/com.termux/files/usr/bin/aapt2 dump badging {1}" | grep -v \'\\(application-label-\\|application-icon-\\)\'',
    actions = {
      ['default'] = function(selected)
        if selected and #selected > 0 then
          local item = string.match(selected[1], '|([%w%.]+) ')
          vim.notify(vim.inspect(item))
        end
      end,
    },
  })
end, {})

-- refresh syntax automatically on file save
vim.api.nvim_create_user_command('SyntaxAutoSyncToggle', function()
  local ok, existing_group = pcall(vim.api.nvim_get_autocmds, { group = 'SyntaxRefresh' })
  if ok and #existing_group > 0 then
    vim.api.nvim_del_augroup_by_name 'SyntaxRefresh'
  end

  local group = vim.api.nvim_create_augroup('SyntaxRefresh', { clear = true })
  local refresh_syntax = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd 'silent! syntax sync fromstart'
        end)
      end
    end
  end

  vim.api.nvim_create_autocmd('BufWritePost', {
    group = group,
    callback = refresh_syntax,
  })
end, { nargs = 0 })

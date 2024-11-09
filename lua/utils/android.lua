local CLOCKWORK_PATH = '~/Projects/Typescript/frida-clockwork/'
vim.g.lastpackage = nil

--- @param device_id string?
--- @param cmd string?
--- @return string
local adb = function(device_id, cmd)
  cmd = cmd or ''
  if device_id then
    return ('adb -s %s %s'):format(device_id, cmd)
  end
  return ('adb %s'):format(cmd)
end

--- @param cb fun(device_id: string|nil)
--- @param opts { skip: boolean? }
local pick_device = function(cb, opts)
  local fzf = require 'fzf-lua'
  if opts.skip then
    local device_id = vim.fn.system 'adb get-serialno'
    if vim.v.shell_error == 0 then
      device_id = device_id:gsub('%s*$', '')
      vim.schedule(function()
        cb(device_id)
      end)
      return
    end
  end

  local cmd = [[adb devices | sed '$ d']]
  fzf.fzf_exec(cmd, {
    winopts = {
      height = 0.65,
      width = 0.50,
    },
    fzf_opts = {
      ['--prompt'] = 'Device> ',
      ['--header-lines'] = '1',
    },
    actions = {
      ['default'] = function(selected)
        if selected and #selected > 0 then
          local item = selected[1]:match '(%S+)'
          cb(item)
        end
      end,
    },
  })
end

--- @param device_id string|nil
--- @param cb fun(package_id)
local pick_package = function(device_id, cb)
  local fzf = require 'fzf-lua'
  local utils = require 'fzf-lua.utils'

  local cmd = adb(device_id, [[shell pm list packages -3 -f -U | sort -r -g -t ':' -k3]])
  local pkgId = function(line)
    return (tostring(line)):match '^([^|]+)|'
  end

  local contents = function(fzf_cb)
    coroutine.wrap(function()
      local co = coroutine.running()

      vim.schedule(function()
        local processline = function(line)
          local path, pkg, uid = line:match '^package:(.-)=([%w%.%-_]+)%s+uid:(%d+)$'
          local entry = string.format('%s|%s %s\n%s', pkg, pkg, utils.ansi_from_hl('Comment', ('uid:%s'):format(uid)), utils.ansi_from_hl('Conceal', path))
          return entry, pkg
        end

        local output = vim.fn.system(cmd)
        local lines = vim.split(output, '\n', { plain = true })
        table.remove(lines)

        local items = {}
        for _, line in pairs(lines) do
          local entry, pkg = processline(line)
          if pkg == vim.g.lastpackage then
            table.insert(items, 0, entry)
          else
            table.insert(items, entry)
          end
        end

        for _, item in pairs(items) do
          fzf_cb(item, function()
            coroutine.resume(co)
          end)
        end
      end)

      coroutine.yield(co)
      fzf_cb()
    end)()
  end

  fzf.fzf_exec(contents, {
    multiline = 2,
    winopts = {
      height = 0.85,
      width = 0.5,
      col = 0.5,
    },
    fzf_opts = {
      ['--border'] = 'top',
      ['--border-label'] = device_id,
      ['--border-label-pos'] = 'top',
      ['--preview-window'] = 'bottom,,border-top',
      ['--prompt'] = 'Package> ',
      ['--delimiter'] = '\\|',
      ['--with-nth'] = '2..',
      ['-i'] = true,
      ['-e'] = true,
      ['--cycle'] = true,
      ['--track'] = true,
      ['--tiebreak'] = 'index',
    },
    preview = [[ adb shell pm dump {1} | grep -A20 '^Packages:' ]],
    actions = {
      ['default'] = function(selected)
        if selected and #selected > 0 then
          local pkg = pkgId(selected[1])
          if pkg ~= nil then
            vim.g.lastpackage = pkg
          end
          cb(pkg)
        end
      end,
    },
  })
end

--- @param callback fun(device_id: string|nil, package_id: string)
local function pick(callback)
  coroutine.wrap(function()
    local co = coroutine.running()
    pick_device(function(device_id)
      coroutine.resume(co, device_id)
    end, { skip = true })
    local device_id = coroutine.yield(co)

    pick_package(device_id, function(package_id)
      coroutine.resume(co, package_id)
    end)
    local package_id = coroutine.yield(co)

    if package_id ~= nil then
      callback(device_id, package_id)
    end
  end)()
end

--- @return Terminal
local function term()
  local Terminal = require('toggleterm.terminal').Terminal
  return Terminal:new {
    id = 5555,
    display_name = 'frida-clockwork',
    dir = CLOCKWORK_PATH,
    close_on_exit = false,
    auto_scroll = true,
    direction = 'horizontal',
    float_opts = {
      border = 'rounded',
    },
  }
end

--- @param device_id string|nil
--- @param package_id string
--- @return string
local format_command = function(device_id, package_id)
  local cmd = 'frida'
  if device_id then
    cmd = cmd .. ' -D ' .. device_id
  end
  cmd = cmd .. ' -f ' .. package_id
  cmd = cmd .. ' -o session.txt'
  cmd = cmd .. ' -l script.js'
  return cmd
end

vim.api.nvim_create_user_command('FridaSpawn', function()
  pick(function(device_id, package_id)
    local cmd = format_command(device_id, package_id)
    local tty = term()
    vim.notify(cmd, vim.log.levels.WARN)
    tty:shutdown()
    tty:open(40, 'horizontal')
    tty:send(cmd)
  end)
end, { nargs = 0 })

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  once = true,
  callback = function()
    local ok, overseer = pcall(require, 'overseer')
    if not ok then
      return
    end

    overseer.new_task {
      name = 'build: watch',
      cwd = CLOCKWORK_PATH,
      strategy = {
        'orchestrator',
        tasks = {
          {
            {
              'shell',
              name = 'tsc: watch',
              cmd = 'npx tsc -b -w',
              cwd = CLOCKWORK_PATH,
              components = {
                {
                  'on_output_parse',
                  parser = {
                    diagnostics = {
                      {
                        'always',
                        {
                          'loop',
                          {
                            'parallel',
                            {
                              'invert',
                              { 'test', 'Watching for file changes%.$' },
                            },
                            {
                              'always',
                              {
                                'extract',
                                { regex = true },
                                '\\v^([^[:space:]].*)[\\(:](\\d+)[,:](\\d+)(\\):\\s+|\\s+-\\s+)(error|warning|info)\\s+TS(\\d+)\\s*:\\s*(.*)$',
                                'filename',
                                'lnum',
                                'col',
                                '_',
                                'type',
                                'code',
                                'text',
                              },
                            },
                            { 'skip_lines', 1 },
                          },
                        },
                      },
                      { 'dispatch', 'set_results' },
                      {
                        'skip_until',
                        { skip_matching_line = true },
                        'File change detected%. Starting incremental compilation%.%.%.$',
                      },
                      { 'dispatch', 'clear_results' },
                    },
                  },
                },
              },
            },
            {
              'shell',
              name = 'webpack: watch',
              cmd = 'npx webpack --config webpack.config.js --watch --stats-error-details',
              cwd = CLOCKWORK_PATH,
              components = {
                {
                  'on_output_parse',
                  parser = {
                    diagnostics = {
                      'loop',
                      {
                        'sequence',
                        { 'extract', { regex = true, append = false }, '\\v^(\\S+):', 'target' },
                        {
                          'always',
                          {
                            'loop',
                            {
                              'sequence',
                              { 'skip_until', { skip_matching_line = true }, '^%s*$' },
                              {
                                'extract',
                                { regex = true, append = false },
                                '\\v^\\s+(ERROR|WARN) in (.+)',
                                'type',
                                'file',
                              },
                              {
                                'skip_lines',
                                1,
                              },
                              {
                                'extract',
                                { regex = true, append = false },
                                '\\v^\\s+\\[(.*)\\] (ERROR|WARN) in (.*)\\((\\d+),(\\d+)\\)',
                                'tag',
                                'type',
                                'file',
                                'lnum',
                                'col',
                              },
                              {
                                'extract',
                                { regex = true },
                                '\\v^\\s+([^:]+): (.+)$',
                                'code',
                                'message',
                              },
                            },
                          },
                        },
                        { 'skip_until', { regex = true }, '\\v^.*\\(webpack [0-9.]*\\).*compiled' },
                        { 'dispatch', 'set_results' },
                      },
                    },
                  },
                },
              },
            },
          },
        },
      },
      components = {
        { 'unique', replace = true, restart_interrupts = true },
      },
    }

    overseer.register_template {
      name = 'frida server',
      params = function()
        local items = {}
        local output = vim.fn.system [[adb devices | sed '1d;$d;s/\\t.*//']]
        if vim.v.shell_error == 0 then
          items = vim.split(output, '\n', { plain = true, trimempty = true })
        end
        return {
          device = {
            desc = 'Adb device',
            type = 'enum',
            default = items[1],
            choices = items,
          },
          file = {
            desc = 'Frida Server file',
            type = 'string',
            default = 'nya-server-arm64',
          },
          cmd = {
            desc = 'Command ran in adb shell',
            type = 'string',
            default = 'su 0',
            optional = true,
          },
        }
      end,
      builder = function(params)
        local file = ('/data/local/tmp/%s'):format(params.file)
        return {
          cmd = { 'adb', '-s', params.device, 'shell', params.cmd, file },
        }
      end,
    }
  end,
})

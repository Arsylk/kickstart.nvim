---@param mode string|string[]
---@param lhs string|string[]
---@param rhs string|function
---@param opts? vim.keymap.set.Opts
local map = function(mode, lhs, rhs, opts)
  ---@cast lhs string[]
  lhs = type(lhs) == 'string' and { lhs } or lhs
  for i, key in pairs(lhs) do
    if i > 1 and opts ~= nil and opts.desc then
      opts.desc = 'which-key.ignore'
    end
    vim.keymap.set(mode, key, rhs, opts)
  end
end
--- @param index number
--- @param desc string
local first_desc = function(index, desc)
  return index == 1 and desc or 'which-key.ignore'
end
--- @param value number
--- @param min number
--- @param max number
local clamp = function(value, min, max)
  return math.min(max, math.max(min, value))
end

-- The good 'ol keybinds
map('n', { '<C-c>', '<D-c>' }, '<cmd>%y+<CR>', { noremap = true, desc = 'File copy whole' })
map('n', { '<C-a>', '<D-a>' }, 'gg^vG$', { desc = 'Select all', noremap = true, silent = true })
map({ 'i', 'n' }, { '<C-s>', '<D-s>' }, '<cmd>w<CR>', { noremap = true, desc = 'File save' })

map('c', { '<C-z>', '<D-z>' }, '<C-r>u', { desc = 'Undo' }) -- Undo
map('n', { '<C-z>', '<D-z>' }, 'u', { desc = 'Undo' }) -- Undo
map('i', { '<C-z>', '<D-z>' }, '<C-o>u', { desc = 'Undo' }) -- Undo
map('t', { '<C-z>', '<D-z>' }, '<C-\\><C-n><C-z>', { desc = 'Undo' }) -- Undo

map('c', { '<C-Z>', '<D-Z>' }, '<C-o><C-r>', { desc = 'Redo' }) -- Redo
map('n', { '<C-Z>', '<D-Z>' }, '<C-r>', { desc = 'Redo' }) -- Redo
map('i', { '<C-Z>', '<D-Z>' }, '<C-o><C-r>', { desc = 'Redo' }) -- Redo
map('t', { '<C-z>', '<D-Z>' }, '<C-\\><C-n><C-z>', { desc = 'Undo' }) -- Undo

-- Activate Ctrl+V as paste
map('c', { '<C-v>', '<D-v>' }, '<c-r>0', { noremap = true, desc = 'Command paste' })
map('n', { '<C-v>', '<D-v>' }, '"+p', { noremap = true, desc = 'Command paste' })
map('i', { '<C-v>', '<D-v>' }, '<c-r>0', { noremap = true, desc = 'Command paste' })
map('t', { '<C-v>', '<D-v>' }, '<C-\\><C-n>"+Pi', { noremap = true, desc = 'Command paste' })

-- Force close all windowns
map('', '<S-Esc><S-Esc><Del>', '<Cmd>qa!<CR>', { nowait = true, noremap = true, desc = 'Instant Quit' })

-- Display diagnostics under cursor
map('n', { '<C-d>', '<D-d>' }, vim.diagnostic.open_float, { desc = 'Show diagnostics under the cursor' })

-- Edit path under cursor
map('n', 'ge', function()
  local path = vim.fn.expand '<cfile>'
  if vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) then
    local cmd = ('edit %s'):format(path)
    vim.cmd(cmd)
  else
    vim.notify(('Missing file:\n%s'):format(path), vim.log.levels.WARN)
  end
end, { desc = 'Edit file under cursor' })

-- Kill current buffer
map('n', '<C-b>Q', '<Cmd>BufDel!<CR>', { desc = 'Kill buffer' })
map('n', '<C-b>q', '<Cmd>BufDel<CR>', { desc = 'Close buffer' })

-- Format content
map('n', { '<C-F>', '<D-F>' }, '<Cmd>ConformFormat<CR>', { noremap = true, desc = '[F]ormat content' })
map('v', { '<C-F>', '<D-F>' }, ':<C-u>ConformFormat<CR>', { noremap = true, desc = '[F]ormat content' })

-- Open ripgrep replace Ctrl+R
map('n', '<C-rp>', function()
  require('rip-substitute').sub()
end, { desc = ' rip substitute' })

-- Move between windows with arrows
-- map('n', '<C-Left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- map('n', '<C-Right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- map('n', '<C-Down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- map('n', '<C-Up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
map('n', '<C-w>n', '<Cmd>new<CR>', { desc = 'Open new window split' })
map('n', '<C-w>N', '<Cmd>vnew<CR>', { desc = 'Open new window split vertical' })

-- Don't yank on delete char
map('n', 'x', '"_x', {})
map('n', 'X', '"_X', {})
map('v', 'x', '"_x', {})
map('v', 'X', '"_X', {})

-- Don't yank on visual paste
map('v', 'p', '"_dP', {})

-- Double Q to close current window
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help' },
  callback = function(params)
    vim.keymap.set('n', 'qq', '<cmd>q<CR>', { noremap = true, buffer = params.buf, desc = 'Close window' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'vim' },
  callback = function(params)
    vim.keymap.set('n', 'qq', '<C-c>', { noremap = true, buffer = params.buf, desc = 'Close window' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'TelescopePrompt', 'fzf' },
  callback = function(params)
    vim.keymap.set('', 'qq', '<Esc>', { noremap = true, buffer = params.buf, desc = 'Close window' })
  end,
})

-- Toggle term specific mappings
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'toggleterm', 'terminal' },
  callback = function(params)
    local buf = params.buf
    local function get_term()
      for _, term in pairs(require('toggleterm.terminal').get_all(true)) do
        if term.bufnr == buf then
          return term
        end
      end
      return nil
    end

    vim.api.nvim_buf_set_keymap(buf, 'n', 'cd', '', {
      callback = function()
        local winnr = vim.fn.bufwinid(buf)
        local lastwin = nil
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if win ~= winnr then
            lastwin = win
            break
          end
        end
        log { win = winnr, last = lastwin }
        if lastwin then
          local lastfile = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(lastwin))
          if lastfile and lastfile ~= '' then
            local folder = vim.fn.fnamemodify(lastfile, ':h'):gsub('^.-://', '')
            local ok = pcall(require('toggleterm.terminal').Terminal.change_dir, get_term(), folder)
            if ok == false then
            end
          end
        end
      end,
      desc = 'Cd into last windows working directory',
    })

    map('n', { '<leader><C-c>', '<leader><D-c>' }, function()
      pcall(require('toggleterm.terminal').Terminal.shutdown, get_term())
    end, {
      desc = 'Shutdown terminal',
    })

    require('snacks.toggle')
      .new({
        name = 'Autoscroll',
        get = function()
          local term = get_term()
          if term then
            return term.auto_scroll
          end
          return true
        end,
        set = function(state)
          local term = get_term()
          if term then
            term.auto_scroll = not state
          end
        end,
      })
      :map '<leader>ts'
  end,
})

-- Break inserted text into smaller undo units
local undo_ch = { ',', '.', '!', '?', ';', ':' }
for _, ch in ipairs(undo_ch) do
  map('i', ch, ch .. '<C-g>u')
end

map('x', '$', 'g_')

-- Open autocomplete from normal mode
map('n', { '<C-Space>', '<D-Space>' }, function()
  local ok, cmp = pcall(require, 'blink-cmp')
  if not ok then
    return
  end
  vim.cmd [[startinsert]]
  cmp.show()
end, { silent = true, desc = 'Open autocomplete' })

-- Keep cursor centered when PgUp & PgDown
map('n', '<PageDown>', '<C-d><C-d>zz', { desc = 'Page down' })
map('n', '<PageUp>', '<C-u><C-u>zz', { desc = 'Page up' })
map('n', '<C-PageDown>', '<C-d>zz', { desc = 'Half page down' })
map('n', '<C-PageUp>', '<C-u>zz', { desc = 'Half page up' })
map('n', 'n', 'nzz', { desc = 'Next', noremap = true })
map('n', 'N', 'Nzz', { desc = 'Previous', noremap = true })

-- Additional buffer navigation
map('', '[b', '<Cmd>bprevious<CR>', { desc = 'previous [b]uffer', silent = true })
map('', ']b', '<Cmd>bnext<CR>', { desc = 'next [b]uffer', silent = true })

-- Overseer toggle window
map('n', '<F12>', '<Cmd>OverseerToggle<CR>', { noremap = true, desc = 'Toggle Overseer window' })
map('n', { '<C-F12>', '<F36>' }, '<Cmd>OverseerRun<CR>', { noremap = true, desc = 'Overseer Run' })
map('n', '<S-F12>', '<Cmd>OverseerRunCmd<CR>', { noremap = true, desc = 'Overseer Run Cmd' })

-- Redirect command output and allow edit
map('c', '<S-CR>', function()
  local route = require('noice.config').options.redirect
  require('noice').redirect(vim.fn.getcmdline(), { route })
end, { desc = 'Redirect Cmdline' })

-- remap keys for "fold all" and "unfold all"
vim.keymap.set('n', 'zR', function()
  require('ufo').openAllFolds()
end, { desc = 'Open all folds' })
vim.keymap.set('n', 'zM', function()
  require('ufo').closeAllFolds()
end, { desc = 'Close all folds' })

-- LSP mappings
map('n', '<leader><leader>', '<Cmd>FzfLua buffers<CR>', { desc = '[ ] Find existing buffers' })
map('n', '<leader>fj', '<Cmd>FzfLua jumps<CR>', { desc = '[F]ind [J]umps' })
map('n', '<leader>fh', '<Cmd>FzfLua help<CR>', { desc = '[F]ind [H]elp' })
map('n', '<leader>fh', '<Cmd>FzfLua highlights<CR>', { desc = '[F]ind [H]ighlights' })
map('n', '<leader>fk', '<Cmd>FzfLua keymaps<CR>', { desc = '[F]ind [K]eymaps' })
map('n', '<leader>ff', '<Cmd>FzfLua files<CR>', { desc = '[F]ind [F]iles' })
map('n', '<leader>fs', '<Cmd>FzfLua builtin<CR>', { desc = '[F]ind [S]elect FzfLua' })
map('n', '<leader>fw', '<Cmd>FzfLua grep_cword<CR>', { desc = '[F]ind current [W]ord' })
map('n', '<leader>fg', '<Cmd>FzfLua live_grep<CR>', { desc = '[F]ind by [G]rep' })
map('n', '<leader>fd', '<Cmd>FzfLua diagnostics_document<CR>', { desc = '[F]ind [D]iagnostics' })
map('n', '<leader>fr', '<Cmd>FzfLua resume<CR>', { desc = '[F]ind [R]esume' })
map('n', '<leader>f.', '<Cmd>FzfLua oldfiles<CR>', { desc = '[F]ind Recent Files [.]' })
map('n', '<leader>fn', '<Cmd>FzfLua files cwd=$HOME/.config/nvim<CR>', { desc = '[F]ind [N]eovim files' })
map('n', '<leader>fy', function()
  require 'neoclip.fzf'()
end, { desc = '[F]ind [Y]ank History' })

-- LSP buffer specific mappings
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('custom-lsp-attach', { clear = true }),
  callback = function(event)
    local lspmap = function(keys, fn, desc)
      vim.keymap.set('n', keys, fn, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    local fzf = require 'fzf-lua'
    lspmap('<leader>cl', vim.lsp.codelens.run, '[C]ode [L]ens')
    lspmap('<leader>ca', fzf.lsp_code_actions, '[C]ode [A]ctions')
    lspmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    lspmap('gf', fzf.lsp_finder, '[G]oto Lsp [F]inder')
    lspmap('gd', fzf.lsp_definitions, '[G]oto [D]efinition')
    lspmap('gr', fzf.lsp_references, '[G]oto [R]eferences')
    lspmap('gi', fzf.lsp_implementations, '[G]oto [I]mplementation')
    lspmap('gt', fzf.lsp_typedefs, '[G]oto [T]ype Definition')
    lspmap('gD', fzf.lsp_declarations, '[G]oto [D]eclarations')
    lspmap('gic', fzf.lsp_incoming_calls, '[G]oto [I]ncoming [C]alls')
    lspmap('goc', fzf.lsp_outgoing_calls, '[G]oto [O]utgoing [C]alls')

    map({ 'n', 'i' }, '<A-k>', vim.lsp.buf.hover, { noremap = true })
  end,
})

-- mappings for Gitsigns, a bit ghetto but zzz
vim.api.nvim_create_autocmd({ 'BufFilePost', 'BufRead', 'BufNewFile', 'BufWritePost' }, {
  callback = function(event)
    local gitsigns = require 'gitsigns'

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = event.buf, desc = 'git: ' .. desc })
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, 'next [c]hange')

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, 'previous [c]hange')

    -- normal mo
    map('n', '<leader>hs', gitsigns.stage_hunk, '[s]tage hunk')
    map('n', '<leader>hr', gitsigns.reset_hunk, '[r]eset hunk')
    map('n', '<leader>hS', gitsigns.stage_buffer, '[S]tage buffer')
    map('n', '<leader>hR', gitsigns.reset_buffer, '[R]eset buffer')
    map('n', '<leader>hp', gitsigns.preview_hunk, '[p]review hunk')
    map('n', '<leader>hi', gitsigns.preview_hunk_inline, '[i]nline hunk')
    map('n', '<leader>hb', function()
      gitsigns.blame_line { full = true }
    end, '[b]lame line')
    map('n', '<leader>hd', gitsigns.diffthis, '[d]iff this')
    map('n', '<leader>hD', function()
      gitsigns.diffthis '~'
    end, '[D]iff last commit')

    -- Toggles
    Snacks.toggle
      .new({
        name = '[t]oggle [w]ord diff',
        get = function()
          return require('gitsigns.config').config.word_diff
        end,
        set = function(state)
          gitsigns.toggle_word_diff(state)
        end,
      })
      :map '<leader>tw'

    Snacks.toggle
      .new({
        name = '[t]oggle [b]lame line',
        get = function()
          return require('gitsigns.config').config.current_line_blame
        end,
        set = function(state)
          gitsigns.toggle_current_line_blame(state)
        end,
      })
      :map '<leader>tb'
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    -- Autopair toggle
    local ok, blink = pcall(require, 'blink.cmp.config')
    if ok then
      Snacks.toggle
        .new({
          name = 'Autocomplete',
          get = function()
            return vim.b.completaion
          end,
          set = function(state)
            vim.b.completion = not state
          end,
        })
        :map '<leader>tb'
      Snacks.toggle
        .new({
          name = 'Autopair',
          get = function()
            return blink.completion.accept.auto_brackets.enabled
          end,
          set = function(state)
            blink.completion.accept.auto_brackets.enabled = not state
          end,
        })
        :map '<leader>tb'
    end
    -- UndoTree toggle
    Snacks.toggle
      .new({
        name = 'Autosave',
        get = function()
          return vim.g.autosave
        end,
        set = function(state)
          if state then
            require('auto-save').on()
          else
            require('auto-save').off()
          end
        end,
      })
      :map '<leader>ta'
    -- Autosave toggle
    Snacks.toggle
      .new({
        name = 'Autoformat',
        get = function()
          return vim.b.autoformat
        end,
        set = function(state)
          vim.b.autoformat = not state
        end,
      })
      :map '<leader>tf'
  end,
})

-- toogle debugger gui
vim.keymap.set('n', '<F7>', function()
  require('dapui').toggle()
end, { desc = 'Debug: See last session result.' })

if vim.g.neovide then
  map('n', '<D-s>', ':w<CR>', { desc = 'which-key.ignore' }) -- Save
  map('n', '<D-z>', 'u', { desc = 'which-key.ignore' }) -- Undo
  map('i', '<D-z>', '<C-o>u', { desc = 'which-key.ignore' }) -- Undo
  map('n', '<D-Z>', '<C-r>', { desc = 'which-key.ignore' }) -- Undo
  map('i', '<D-Z>', '<C-o><C-r>', { desc = 'which-key.ignore' }) -- Undo
  map('v', '<D-c>', '"+y', { desc = 'which-key.ignore' }) -- Copy
  -- map('n', '<D-v>', '"+p', { desc = 'which-key.ignore' }) -- Paste normal mode
  -- map('t', '<D-v>', '<ESC>"+Pi', { desc = 'which-key.ignore' }) -- Paste terminal mode
  -- map('l', '<D-v>', '<ESC>"+Pi', { desc = 'which-key.ignore' }) -- Paste terminal mode
  -- map('v', '<D-v>', '"+P', { desc = 'which-key.ignore' }) -- Paste visual mode
  -- map('c', '<D-v>', '<C-R>+', { desc = 'which-key.ignore' }) -- Paste command mode
  -- map('i', '<D-v>', '<ESC>l"+Pli', { desc = 'which-key.ignore' }) -- Paste insert mode

  vim.g.neovide_window_blurred = true
  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end

  -- Set transparency and background color (title bar color)
  vim.g.neovide_opacity = 0.8
  vim.g.neovide_normal_opacity = 0.8
  -- Add keybinds to change transparency
  local change_transparency = function(delta)
    vim.g.neovide_opacity = clamp(vim.g.neovide_opacity + delta, 0.0, 1.0)
    vim.g.neovide_normal_opacity = clamp(vim.g.neovide_opacity + delta, 0.0, 1.0)
  end
  for _, key in pairs { 'C', 'D' } do
    map('n', string.format('<%s-]>', key), function()
      change_transparency(0.05)
    end, { desc = first_desc 'Increase transparency' })
    map('n', string.format('<%s-[>', key), function()
      change_transparency(-0.05)
    end, { desc = first_desc 'Decrease transparency' })
    map('n', string.format('<%s-+>', key), function()
      change_scale_factor(1.1)
    end, { desc = first_desc 'Increase font size' })
    map('n', string.format('<%s-_>', key), function()
      change_scale_factor(1 / 1.1)
    end, { desc = first_desc 'Decrease font size' })
    map('n', string.format('<%s-)>', key), function()
      vim.g.neovide_scale_factor = 1.0
    end, { desc = first_desc 'Reset font size' })
  end
end
map('v', { '<C-r>n', '<D-r>n' }, function()
  local register = 'z'
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"

  -- Yank and delete
  vim.cmd('normal! "' .. register .. 'y')
  vim.cmd 'normal! gvd'

  -- Return to normal mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)

  -- Create a temp file and write selected text to it
  local tmpfile = vim.fn.tempname()

  local data = vim.fn.split(vim.fn.getreg(register), '\n')
  vim.fn.writefile(data, tmpfile)

  local cmd = string.format(
    [[node --experimental-vm-modules --eval 'const vm = require("node:vm");const fs = require("node:fs");const util = require("util");util.inspect.defaultOptions.maxArrayLength = null;util.inspect.defaultOptions.maxStringLength = null;util.inspect.defaultOptions.depth = null;console.log(new vm.Script(fs.readFileSync("%s", "utf-8")).runInThisContext())']],
    tmpfile
  )
  -- log(cmd)
  local shell_output = vim.fn.system(cmd)

  -- log(shell_output)
  if vim.v.shell_error ~= 0 then
    vim.notify(shell_output, 'error', {})
  else
    vim.fn.setreg(register, vim.fn.trim(shell_output, '\n'))
    vim.cmd('normal! "' .. register .. 'P')
  end

  -- Clean up
  vim.fn.delete(tmpfile)
end, { desc = 'replace eval node' })

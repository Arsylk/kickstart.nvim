local map = vim.keymap.set

-- The good 'ol keybinds
map('n', '<C-a>', 'ggVG$', { noremap = true, silent = true })
map({ 'i', 'n' }, '<C-s>', '<cmd>w<CR>', { noremap = true, desc = 'File save' })
map('n', '<C-c>', '<cmd>%y+<CR>', { desc = 'File copy whole' })

-- Activate Ctrl+V as paste
map('c', '<C-v>', function()
  local pos = vim.fn.getcmdpos()
  local text = vim.fn.getcmdline()
  local lt = text:sub(1, pos - 1)
  local rt = text:sub(pos)
  local clip = vim.fn.getreg '+'
  vim.fn.setcmdline(lt .. clip .. rt, pos + clip:len())
  vim.cmd [[echo '' | redraw]]
end, { noremap = true, desc = 'Command paste' })
map('n', '<C-v>', '"+p', { desc = 'Command paste' })
map('i', '<C-v>', '<cmd>normal "+p<CR>', { noremap = true, desc = 'Command paste' })

-- Move between windows with arrows
map('n', '<C-Left>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-Right>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-Down>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-Up>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Double Q to close current window
--map('n', 'qq', '<CMD>q<CR>', { silent = true, desc = 'CLose window' })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'vim' },
  callback = function(params)
    vim.keymap.set('n', 'qq', '<C-c>', { noremap = true, buffer = params.buf })
  end,
})

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'TelescopePrompt' },
--   callback = function(params)
--     vim.keymap.set('n', 'qq', '<Esc>', { buffer = params.buf })
--   end,
-- })

-- Keep cursor centered when PgUp & PgDown
map('n', '<PgDown>', '<C-d><C-d>', { desc = 'Page down' })
map('n', '<PgUp>', '<C-u><C-u>', { desc = 'Page up' })
map('n', '<C-d>', '<C-d>zz', { desc = 'Half page down' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Half page up' })
map('n', 'n', 'nzzzv', { desc = 'so and so...' })
map('n', 'N', 'Nzzzv', { desc = 'so and so...' })

-- Redirect command output and allow edit
map('c', '<S-CR>', function()
  require('noice').redirect(vim.fn.getcmdline())
end, { desc = 'Redirect Cmdline' })

-- LSP mappings
-- local builtin = function() require('fzf-lua' end
map('n', '<leader><leader>', function()
  require('fzf-lua').buffers()
end, { desc = '[ ] Find existing buffers' })
map('n', '<leader>fh', function()
  require('fzf-lua').help_tags()
end, { desc = '[F]ind [H]elp' })
map('n', '<leader>fk', function()
  require('fzf-lua').keymaps()
end, { desc = '[F]ind [K]eymaps' })
map('n', '<leader>ff', function()
  require('fzf-lua').find_files()
end, { desc = '[F]ind [F]iles' })
map('n', '<leader>fs', function()
  require('fzf-lua').builtin()
end, { desc = '[F]ind [S]elect Telescope' })
map('n', '<leader>fw', function()
  require('fzf-lua').grep_string()
end, { desc = '[F]ind current [W]ord' })
map('n', '<leader>fg', function()
  require('fzf-lua').live_grep()
end, { desc = '[F]ind by [G]rep' })
map('n', '<leader>fd', function()
  require('fzf-lua').diagnostics()
end, { desc = '[F]ind [D]iagnostics' })
map('n', '<leader>fr', function()
  require('fzf-lua').resume()
end, { desc = '[F]ind [R]esume' })
map('n', '<leader>f.', function()
  require('fzf-lua').oldfiles()
end, { desc = '[F]ind Recent Files [.]' })
vim.keymap.set('n', '<leader>fn', '<Cmd>FzfLua files cwd=$HOME/.config/nvim<CR>', { desc = '[F]ind [N]eovim files' })

-- map('n', '<leader>fy', extensions.yank_history.yank_history, { desc = '[F]ind [Y]ank History' })

-- LSP buffer specific mappings
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('custom-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, fn, desc)
      vim.keymap.set('n', keys, fn, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    local fzf = require 'fzf-lua'
    map('<leader>ca', fzf.lsp_code_actions, '[C]ode [A]ctions')
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

    map('gf', fzf.lsp_definitions, '[G]oto Lsp [F]inder')
    map('gd', fzf.lsp_definitions, '[G]oto [D]efinition')
    map('gr', fzf.lsp_references, '[G]oto [R]eferences')
    map('gi', fzf.lsp_implementations, '[G]oto [I]mplementation')
    map('gt', fzf.lsp_typedefs, '[G]oto [T]ype Definition')
    map('gD', fzf.lsp_declarations, '[G]oto [D]eclarations')
    map('gic', fzf.lsp_incoming_calls, '[G]oto [I]ncoming [C]alls')
    map('goc', fzf.lsp_outgoing_calls, '[G]oto [O]utgoing [C]alls')

    vim.keymap.set({ 'n', 'i' }, '<A-k>', vim.lsp.buf.hover, { noremap = true })
  end,
})

-- mappings for Gitsigns, a bit ghetto but zzz
vim.api.nvim_create_autocmd({ 'BufFilePost', 'BufRead', 'BufNewFile', 'BufWritePost' }, {
  callback = function(event)
    local gitsigns = require 'gitsigns'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = event.bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git [C]hange' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git [C]hange' })

    -- normal mode
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
    map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
    map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
    map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
    map('n', '<leader>hD', function()
      gitsigns.diffthis '@'
    end, { desc = 'git [D]iff against last commit' })
    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
    map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
  end,
})

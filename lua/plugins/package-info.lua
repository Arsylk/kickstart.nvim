return {
  {
    'vuki656/package-info.nvim',
    event = 'BufEnter package.json',
    opts = {
      autostart = true,
      pacakge_manager = 'npm',
    },
  },
}

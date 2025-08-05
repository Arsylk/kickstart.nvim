return {
  'saghen/blink.pairs',
  dependencies = 'saghen/blink.download',
  version = '*',
  -- build = 'cargo build --release',
  opts = {
    mappings = {
      enabled = false,
    },
    highlights = {
      enabled = true,
      groups = {
        'rainbow1',
        'rainbow2',
        'rainbow3',
        'rainbow4',
        'rainbow5',
        'rainbow6',
      },
      matchparen = {
        enabled = true,
        group = 'Visual',
      },
    },
  },
}

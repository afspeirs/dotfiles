return {
  'nvim-mini/mini.nvim',
  version = false,
  config = function()
    require('mini.completion').setup()
    require('mini.files').setup()
    require('mini.move').setup()
    require('mini.notify').setup()
    require('mini.statusline').setup()
  end,
  keys = {
    { '<leader>e', function() require('mini.files').open() end, desc = 'Explorer' },
    { '<leader>E', function() require('mini.files').open(vim.api.nvim_buf_get_name(0)) end, desc = 'Explorer (buffer location)' },
  }
}

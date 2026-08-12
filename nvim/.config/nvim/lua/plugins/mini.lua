return {
  'nvim-mini/mini.nvim',
  version = false,
  lazy = false,
  config = function()
    require('mini.cmdline').setup()
    require('mini.completion').setup()
    require('mini.cursorword').setup()
    require('mini.files').setup({
      windows = {
        preview = true,
        width_preview = 80,
      }
    })
    require('mini.icons').setup()
    require('mini.move').setup()
    require('mini.notify').setup()
    require('mini.statusline').setup()
    -- require('mini.tabline').setup()

    -- Disable mini.completion inside snacks.nvim pickers
    local mini_augroup = vim.api.nvim_create_augroup("MiniConfig", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = mini_augroup,
      pattern = "snacks_picker_input",
      callback = function()
        vim.b.minicompletion_disable = true
      end,
    })
  end,

  keys = {
    { '<leader>e', function() require('mini.files').open() end, desc = 'Explorer' },
    { '<leader>E', function() require('mini.files').open(vim.api.nvim_buf_get_name(0)) end, desc = 'Explorer (buffer location)' },
  },
}

return {
  "gbprod/nord.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("nord").setup({
      borders = true,
      terminal_colors = true,
      transparent = true,
    })
    vim.cmd.colorscheme("nord")
  end,
}

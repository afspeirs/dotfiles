-- Nord Color Scheme
return {
  "gbprod/nord.nvim",
  lazy = false,       -- Load immediately on startup
  priority = 1000,    -- High priority to apply colors before other plugins
  config = function()
    require("nord").setup({
      transparent = true, -- Set to true if you want your terminal's transparent background
      terminal_colors = true,
      borders = true,      -- Border line between vertical splits
    })
    vim.cmd.colorscheme("nord") -- Apply Nord
  end,
}


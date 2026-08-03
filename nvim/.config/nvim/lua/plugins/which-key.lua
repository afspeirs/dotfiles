return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.opt.timeout = true
    vim.opt.timeoutlen = 300
  end,
  opts = {
    preset = "helix",
    spec = {
      { "<leader>b", group = "Buffers", icon = "󰓩 " },
      { "<leader>c", group = "Code", icon = "󰅩 " },
      { "<leader>f", group = "Files", icon = "󰍉 " },
      { "<leader>g", group = "Git", icon = "󰊢 " },
      { "<leader>h", group = "Harpoon", icon = "󰛢 " },
    },
  },
}

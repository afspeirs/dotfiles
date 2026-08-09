return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.opt.timeout = true
    vim.opt.timeoutlen = 300
  end,
  opts = {
    preset = "helix",
    sort = { "local", "alphanum" },
    spec = {
      { "<leader>b", group = "Buffers", icon = "󰓩 " },
      { "<leader>c", group = "Code", icon = "󰅩 " },
      { "<leader>e", desc = "Explorer", icon = "󰝰 " },
      { "<leader>E", desc = "Explorer (buffer location)", icon = "󰝰 " },
      { "<leader>f", group = "Files", icon = "󰍉 " },
      { "<leader>g", group = "Git", icon = "󰊢 " },
      { "<leader>h", group = "Harpoon", icon = "󰛢 " },

      -- Save & Quit
      { "<leader>w", desc = "Save File", icon = "󰆓 " },
      { "<leader>q", desc = "Quit Neovim", icon = " " },
      { "<leader>W", desc = "Toggle Line Wrap", icon = "󰛲 " },

      -- Windows
      { "<leader>-", desc = "Horizontal Split", icon = "󱧖 " },
      { "<leader>=", desc = "Vertical Split", icon = "󱧕 " },
      { "<leader><BS>", desc = "Close current split", icon = "󰅖 " },

      -- Yank / Replace / Comment
      { "<leader>y", desc = "Yank to system clipboard", icon = "󰅪 " },
      { "<leader>Y", desc = "Yank line to system clipboard", icon = "󰅪 " },
      { "<leader>cp", desc = "Replace word under cursor in file", icon = "󰷉 " },
    },
  },
}

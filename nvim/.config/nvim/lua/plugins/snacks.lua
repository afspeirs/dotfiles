return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile   = { enabled = true },
    dashboard = { enabled = true },
    indent    = { enabled = true },
    lazygit   = { enabled = true, win = { width = 0, height = 0 } },
    picker    = { enabled = true },
  },
  keys = {
    -- File
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Search Text in Project" },

    -- Buffer
    { "<leader><leader>", function() Snacks.picker.buffers() end, desc = "View Buffers" },
    { "<leader>bb", function() Snacks.picker.buffers() end, desc = "View Buffers" },
    { "<leader>bc", "<cmd>enew<cr>", desc = "New Empty Buffer" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>bD", function() Snacks.bufdelete.other() end, desc = "Delete All Other Buffers" },
    { "<leader>bs", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>bS", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
    { "<leader>bl", "<cmd>bnext<cr>", desc = "Next Buffer" },
    { "<leader>bn", "<cmd>bnext<cr>", desc = "Next Buffer" },

    -- Git
    { "<leader>gg", function() Snacks.lazygit() end, desc = "LazyGit" },
  },
}

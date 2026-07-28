return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile   = { enabled = true },
    dashboard = { enabled = true },
    indent    = { enabled = true },
    picker    = { enabled = true },
  },
  keys = {
    -- File
    { "<leader><leader>", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Search Text in Project" },

    -- Buffer
    { "<leader>bb", function() Snacks.picker.buffers() end, desc = "Find / View Buffers" },
    { "<leader>bn", "<cmd>enew<cr>", desc = "New Empty Buffer" },
    { "<leader>bk", function() Snacks.bufdelete() end, desc = "Kill Buffer" },
    { "<leader>ba", function() Snacks.bufdelete.other() end, desc = "Delete All Other Buffers" },
    { "<leader>bs", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>bS", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
    { "<leader>bl", "<cmd>bnext<cr>", desc = "Next Buffer" },
  },
}

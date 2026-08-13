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
    styles    = {
      lazygit = {
        wo = {
          winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:FloatBorder",
        },
      },
    },
  },
  keys = {
    -- File
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Search Text (Grep)" },

    -- Search
    { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Search Word", mode = { "n", "x" } },

    -- LSP Symbols
    { "<leader>cs", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols (buffer)" },
    { "<leader>cS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

    -- Buffer
    { "<leader><leader>", function() Snacks.picker.buffers() end, desc = "View Buffers" },
    { "<leader>bb", function() Snacks.picker.buffers() end, desc = "View Buffers" },
    { "<leader>bc", "<cmd>enew<cr>", desc = "New Empty Buffer" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>bD", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
    { "<leader>bs", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>bS", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
    { "<leader>bl", "<cmd>bnext<cr>", desc = "Next Buffer" },
    { "<leader>bn", "<cmd>bnext<cr>", desc = "Next Buffer" },

    -- Git
    { "<leader>gg", function() Snacks.lazygit() end, desc = "LazyGit" },
  },
}

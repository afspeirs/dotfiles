return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    picker    = { enabled = true },
    lazygit   = { enabled = true },
    dashboard = { enabled = true },
    bigfile   = { enabled = true },
    indent    = { enabled = true },
  },
  keys = {
    -- Fuzzy Find Files (Cmd/Ctrl + P replacement)
    { "<leader><leader>", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
    { "<leader>fs", function() Snacks.picker.smart() end, desc = "Smart Files (Frecency)" },
    -- Live Grep (Search string across project)
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Search Text in Project" },
    -- Open Buffers
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find Open Buffers" },
    -- LazyGit
    { "<leader>gg", function() Snacks.lazygit() end, desc = "LazyGit" },
    -- Open active file on GitHub
    -- { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse (GitHub)" },
  },
}


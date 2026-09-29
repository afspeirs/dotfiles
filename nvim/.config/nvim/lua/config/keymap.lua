local map = vim.keymap.set

-- Save & Quit
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save File" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit Neovim" })

-- Toggle Line Wrap
map("n", "<leader>W", function() vim.wo[0].wrap = not vim.wo[0].wrap end, { desc = "Toggle Line Wrap" })

-- Windows: Splitting
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Horizontal Split" })
map("n", "<leader>=", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
map("n", "<leader><BS>", "<cmd>close<cr>", { desc = "Close current split" })

-- Movement: keep cursor centered in view
map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "=ap", "ma=ap'a")

-- Clipboard yank (asbjornHaland remap)
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
map({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })
map("n", "<leader>P", [["+P]], { desc = "Paste before from system clipboard" })

-- Disable Q
map("n", "Q", "<nop>")

-- Visual: stay in visual mode when indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Comments
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle Comment Line" })
map("v", "<leader>/", "gc", { remap = true, desc = "Toggle Comment Selection" })

-- Search & Replace
map("n", "<leader>cp", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
  desc = "Replace word under cursor in file",
})
map("v", "<leader>cp", [[:s/\%V//g<Left><Left>]], {
  desc = "Replace inside visual selection",
})

-- Sorting Lines (visual)
map("v", "<leader>ss", ":sort<CR>", { desc = "Sort lines" })
map("v", "<leader>su", ":sort u<CR>", { desc = "Sort unique lines" })
map("v", "<leader>sn", ":sort n<CR>", { desc = "Sort lines numerically" })

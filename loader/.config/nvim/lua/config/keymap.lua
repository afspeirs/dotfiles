local map = vim.keymap.set

-- Quick Save & Quit
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save File" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit Neovim" })

-- Window Navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window splitting
vim.keymap.set("n", "-", "<cmd>split<cr>", { desc = "Horizontal Split" })
vim.keymap.set("n", "=", "<cmd>vsplit<cr>", { desc = "Vertical Split" })
vim.keymap.set("n", "<leader><BS>", "<cmd>close<cr>", { desc = "Close current split" })

-- Stay in visual mode when indenting text
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Toggle Comment Line (Normal Mode)
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle Comment Line" })
-- Toggle Comment Selection (Visual Mode)
map("v", "<leader>/", "gc", { remap = true, desc = "Toggle Comment Selection" })

-- Sorting Lines
map("v", "<leader>ss", ":sort<CR>", { desc = "Sort lines" })
map("v", "<leader>su", ":sort u<CR>", { desc = "Sort unique lines" })
map("v", "<leader>sn", ":sort n<CR>", { desc = "Sort lines numerically" })

-- Replace word under cursor across the whole file
map("n", "<leader>cp", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
  desc = "Replace word under cursor in file",
})
-- Replace word under cursor in visual selection
map("v", "<leader>cp", [[:s/\%V//g<Left><Left>]], {
  desc = "Replace inside visual selection",
})

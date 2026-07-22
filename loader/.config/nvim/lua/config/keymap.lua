local map = vim.keymap.set

-- Quick Save & Quit
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save File" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit Neovim" })

-- Window Navigation (VS Code / Zed muscle memory)
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- File Explorer
map("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Open File Explorer" })

-- Stay in visual mode when indenting text
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Toggle Comment Line (Normal Mode)
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle Comment Line" })

-- Toggle Comment Selection (Visual Mode)
map("v", "<leader>/", "gc", { remap = true, desc = "Toggle Comment Selection" })

-- Move line down/up (Normal Mode)
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
-- Move highlighted block down/up and keep selection (Visual Mode)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move block down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move block up" })

-- Sorting Lines
map("v", "<leader>ss", ":sort<CR>", { desc = "Sort lines" })
map("v", "<leader>su", ":sort u<CR>", { desc = "Sort unique lines" })
map("v", "<leader>sn", ":sort n<CR>", { desc = "Sort lines numerically" })

-- Replace word under cursor across the whole file
map("n", "<leader>rp", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
  desc = "Replace word under cursor in file",
})
-- Replace word under cursor in visual selection
map("v", "<leader>rp", [[:s/\%V//g<Left><Left>]], {
  desc = "Replace inside visual selection",
})

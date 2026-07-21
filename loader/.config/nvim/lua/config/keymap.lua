local map = vim.keymap.set

-- Quick Save & Quit
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save File" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit Neovim" })

-- Window Navigation (VS Code / Zed muscle memory)
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- File Explorer (Built-in netrw)
map("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Open File Explorer" })

-- Stay in visual mode when indenting text
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Toggle Comment Line (Normal Mode)
vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle Comment Line" })

-- Toggle Comment Selection (Visual Mode)
vim.keymap.set("v", "<leader>/", "gc", { remap = true, desc = "Toggle Comment Selection" })

-- Move selected lines up/down in Visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move block down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move block up" })

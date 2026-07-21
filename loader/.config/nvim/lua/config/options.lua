local opt = vim.opt

-- Line numbers & UI
opt.number = true          -- Show line numbers
opt.relativenumber = true  -- Relative line numbers for quick jumping
opt.cursorline = true      -- Highlight current line
opt.termguicolors = true   -- True color support
opt.signcolumn = "yes"     -- Always show sign column (prevents shift when LSP loads)

-- Tabs & Indentation (2 spaces for Web Dev standard)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Search settings
opt.ignorecase = true      -- Ignore case in searches...
opt.smartcase = true       -- ...unless capital letters are typed

-- Quality of Life
opt.clipboard = "unnamedplus" -- Sync with system clipboard (Fedora + macOS)
opt.scrolloff = 8             -- Keep 8 lines above/below cursor when scrolling
opt.splitright = true         -- Vertical splits open to the right
opt.splitbelow = true         -- Horizontal splits open below

local opt = vim.opt

-- Line numbers & UI
opt.number = true             -- Show line numbers
opt.relativenumber = true     -- Relative line numbers for quick jumping
opt.cursorline = true         -- Highlight current line
opt.termguicolors = true      -- True color support
opt.signcolumn = "yes"        -- Always show sign column (prevents shift when LSP loads)

-- Tabs & Indentation (2 spaces for Web Dev standard)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Search settings
opt.ignorecase = true         -- Ignore case in searches...
opt.smartcase = true          -- ...unless capital letters are typed

-- Quality of Life
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.scrolloff = 8             -- Keep 8 lines above/below cursor when scrolling
opt.splitright = true         -- Vertical splits open to the right
opt.splitbelow = true         -- Horizontal splits open below

-- Show trailing characters
opt.list = true
opt.listchars = {
  tab = "» ",
  trail = "·",
  extends = "⟩",
  precedes = "⟨",
  nbsp = "␣",
}

-- Ensure file ends with a single newline
opt.fixeol = true
-- Trim trailing whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- trailing whitespace on lines
    vim.cmd([[%s/\s\+$//e]])
    -- trailing blank lines → single newline
    vim.cmd([[%s/\(\n\n\)\+\%$/\r/e]])
  end,
  desc = "Trim trailing whitespace and ensure final newline on save",
})

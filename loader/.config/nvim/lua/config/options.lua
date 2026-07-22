local opt = vim.opt

-- Line numbers & UI
opt.number = true             -- Show line numbers
opt.relativenumber = true     -- Relative line numbers for quick jumping
opt.cursorline = true         -- Highlight current line
opt.termguicolors = true      -- True color support
opt.signcolumn = "yes"        -- Always show sign column (prevents shift when LSP loads)
vim.opt.cmdheight = 0         -- Hide the bottom command line until typing a command
vim.opt.showmode = false      -- Hide default mode message (handled by lualine plugin)

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
local clean_on_save = vim.api.nvim_create_augroup("CleanOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = clean_on_save,
  pattern = "*",
  desc = "Trim trailing whitespace and trailing blank lines on save",
  callback = function()
    local save = vim.fn.winsaveview() -- Save view/cursor position so the screen doesn't jump on save

    vim.cmd([[keeppatterns %s/\s\+$//e]]) -- Trim trailing whitespace at the end of lines
    vim.cmd([[keeppatterns %s/\n\+\%$//e]]) -- Remove all trailing blank lines at the end of the file

    vim.fn.winrestview(save) -- Restore cursor position
  end,
})

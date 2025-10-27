-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Create an augroup for autocmds
local autocmd_group = vim.api.nvim_create_augroup("CustomFileActions", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = autocmd_group,
  pattern = "*", -- Apply to all file types
  callback = function()
    local view = vim.fn.winsaveview()
    -- Trim trailing whitespace
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    -- Remove multiple trailing newlines and add a single one if missing
    -- vim.cmd([[keeppatterns %s/\n\+$/\r/e]])
    vim.fn.winrestview(view)
  end,
  desc = "Trim trailing whitespace and ensure final newline on save",
})

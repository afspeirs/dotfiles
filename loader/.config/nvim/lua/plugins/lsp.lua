return {
  {
    "williamboman/mason.nvim",
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "hover error" })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "definition" })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "code actions" })
    end
  },
}

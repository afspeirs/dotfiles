return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.config").setup({
      ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
        "svelte",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "lua",
        "vim",
        "json",
        "jsonc"
      },
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    })
  end,
}

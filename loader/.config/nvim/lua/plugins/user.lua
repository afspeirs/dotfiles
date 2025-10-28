return {
  "AstroNvim/astrocore",
  opts = {
    mappings = {
      n = {
        ["<M-j>"] = { "<cmd>m .+1<CR>==", desc = "Move line down" },
        ["<M-k>"] = { "<cmd>m .-2<CR>==", desc = "Move line up" },
      },
      v = {
        ["<M-j>"] = { ":m '>+1<CR>gv=gv", desc = "Move selection down" },
        ["<M-k>"] = { ":m '<-2<CR>gv=gv", desc = "Move selection up" },
      },
    },
  },
}

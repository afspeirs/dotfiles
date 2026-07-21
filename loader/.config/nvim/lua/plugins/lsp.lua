return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = "Mason",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "ts_ls",
        "svelte",
        "cssls",
        "html",
        "lua_ls",
        "jsonls",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local servers = {
        "ts_ls",
        "svelte",
        "cssls",
        "html",
        "jsonls",
      }

      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
        vim.lsp.enable(server)
      end

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })
      vim.lsp.enable("lua_ls")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp", { clear = true }),
        callback = function(args)
          local map = vim.keymap.set
          local buf = args.buf
          map("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
          map("n", "K", vim.lsp.buf.hover, { buffer = buf, desc = "Hover documentation" })
          map("n", "gi", vim.lsp.buf.implementation, { buffer = buf, desc = "Go to implementation" })
          map("n", "gr", vim.lsp.buf.references, { buffer = buf, desc = "Show references" })
          map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = buf, desc = "Rename symbol" })
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code action" })
          map("n", "[d", vim.diagnostic.goto_prev, { buffer = buf, desc = "Previous diagnostic" })
          map("n", "]d", vim.diagnostic.goto_next, { buffer = buf, desc = "Next diagnostic" })
          map("n", "<leader>d", vim.diagnostic.open_float, { buffer = buf, desc = "Show line diagnostics" })
        end,
      })
    end,
  },
}

return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  keys = {
    { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
  },
  config = function()
    local directions = {
      ["<c-h>"] = { cmd = "TmuxNavigateLeft", tmux = "-L" },
      ["<c-j>"] = { cmd = "TmuxNavigateDown", tmux = "-D" },
      ["<c-k>"] = { cmd = "TmuxNavigateUp", tmux = "-U" },
      ["<c-l>"] = { cmd = "TmuxNavigateRight", tmux = "-R" },
      ["<c-\\>"] = { cmd = "TmuxNavigatePrevious", tmux = "-l" },
    }

    local function is_lazygit_terminal(buf)
      return vim.bo[buf].buftype == "terminal"
        and vim.api.nvim_buf_get_name(buf):lower():find("lazygit", 1, true) ~= nil
    end

    for key, direction in pairs(directions) do
      vim.keymap.set("t", key, function()
        if vim.api.nvim_win_get_config(0).relative ~= "" and vim.env.TMUX then
          vim.fn.system({ "tmux", "select-pane", direction.tmux })
          return
        end

        vim.cmd("stopinsert")
        vim.cmd(direction.cmd)

        if vim.bo.buftype == "terminal" then
          vim.schedule(function()
            vim.cmd("startinsert")
          end)
        end
      end, { silent = true })
    end

    local group = vim.api.nvim_create_augroup("LazygitTerminalInsert", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "TermOpen", "FocusGained" }, {
      group = group,
      callback = function(args)
        if not is_lazygit_terminal(args.buf) then
          return
        end

        vim.schedule(function()
          if vim.api.nvim_get_current_buf() == args.buf then
            vim.cmd("startinsert")
          end
        end)
      end,
    })
  end,
}

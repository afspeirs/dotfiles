-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


---
-- Helper function to wrap visually selected text with a tag.
-- This is designed to be called from the <C-R>= expression register
-- after a 'c' (change) operation in visual mode.
---
function _G.WrapWithTag()
  -- 1. Get the text that was just selected and 'changed' (deleted)
  --    The 'c' command automatically puts this text in the default register (").
  local text = vim.fn.getreg('"')

  -- 2. Prompt the user for the tag name, defaulting to 'p'
  local tag_name = vim.fn.input('Tag: ', 'p')

  -- 3. Handle cancellation (if user presses <Esc> at the prompt)
  if tag_name == nil then
    -- If cancelled, just return the original text.
    -- This effectively cancels the 'c' operation.
    return text
  end

  -- 4. Handle empty input (if user just presses <Enter>)
  if tag_name == '' then
    -- If the user enters an empty tag, cancel the wrap
    -- and just return the original text.
    print("Tag wrapping cancelled (empty tag).")
    return text
  end

  -- 5. Build and return the new, wrapped string
  --    This string will be inserted by the <C-R>= command.
  local replacement = "<" .. tag_name .. ">" .. text .. "</" .. tag_name .. ">"
  return replacement
end

-- ---
-- -- The Keymap
-- ---
-- This maps <leader>w in Visual mode.
-- <leader> is typically the backslash key: \
vim.keymap.set('v', '<leader>t', 'c<C-R>=_G.WrapWithTag()<CR><Esc>', {
  noremap = true,
  silent = true,
  desc = "Wrap selection with an interactive HTML/XML tag"
})

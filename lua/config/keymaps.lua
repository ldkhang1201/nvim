-- General editor keymaps.
-- Plugin-specific maps live with their plugin spec (see lua/plugins/*).
local map = vim.keymap.set

-- Move 10 lines at a time
map("n", "<C-j>", "10j", { desc = "Move 10 lines down" })
map("n", "<C-k>", "10k", { desc = "Move 10 lines up" })

-- Move through the file while keeping the cursor on the same screen row.
local function move_and_scroll(direction)
  local view = vim.fn.winsaveview()
  local next_line = math.max(1, math.min(view.lnum + direction * vim.v.count1, vim.api.nvim_buf_line_count(0)))
  local moved = next_line - view.lnum
  if moved == 0 then return end

  view.lnum = next_line
  view.topline = math.max(1, view.topline + moved)
  vim.fn.winrestview(view)
end

map("n", "<leader>j", function() move_and_scroll(1) end, { desc = "Move down one line and scroll" })
map("n", "<leader>k", function() move_and_scroll(-1) end, { desc = "Move up one line and scroll" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

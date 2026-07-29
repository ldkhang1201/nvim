-- General editor keymaps.
-- Plugin-specific maps live with their plugin spec (see lua/plugins/*).
local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

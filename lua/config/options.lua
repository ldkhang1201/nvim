-- Leader keys must be set before lazy.nvim loads.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserPythonIndent", { clear = true }),
  pattern = "python",
  callback = function(event)
    vim.bo[event.buf].tabstop = 4
    vim.bo[event.buf].shiftwidth = 4
    vim.bo[event.buf].softtabstop = 4
  end,
})

-- Search
opt.ignorecase = true
opt.smartcase = true

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 250
opt.jumpoptions = "stack,view,clean"
opt.undofile = true

-- System clipboard
opt.clipboard = "unnamedplus"

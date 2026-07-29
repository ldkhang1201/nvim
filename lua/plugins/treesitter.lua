return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- stable classic config API
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "rust", "python", "go", "lua", "vim", "vimdoc" },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}

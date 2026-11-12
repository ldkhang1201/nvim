return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false, -- load at startup
    priority = 1000, -- ensure it loads before other UI plugins
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        transparent_background = false,

        integrations = {
          treesitter = true,
          telescope = true,
          gitsigns = true,
          treesitter_context = true,
          native_lsp = {
            enabled = true,
          },
        },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}

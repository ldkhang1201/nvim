return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fg", function() require("telescope").extensions.live_grep_args.live_grep_args() end, desc = "Live grep (rg args)" },
    { "<leader>fw", function() require("telescope-live-grep-args.shortcuts").grep_word_under_cursor() end, desc = "Grep word under cursor" },
    { "<leader>fw", function() require("telescope-live-grep-args.shortcuts").grep_visual_selection() end, mode = "x", desc = "Grep selection" },
    { "<leader>fr", "<cmd>Telescope resume<CR>", desc = "Resume last picker" },
    { "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
    { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search in buffer" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
  },
  config = function()
    local telescope = require("telescope")
    local lga_actions = require("telescope-live-grep-args.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        layout_config = { horizontal = { preview_width = 0.55 } },
      },
      extensions = {
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
            },
          },
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")
  end,
}

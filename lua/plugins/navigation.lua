return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      max_lines = 4,
      multiline_threshold = 1,
      trim_scope = "outer",
    },
    keys = {
      { "[x", function() require("treesitter-context").go_to_context(vim.v.count1) end, desc = "Jump to enclosing context" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      local objects = {
        f = "@function",
        c = "@class",
        a = "@parameter",
      }
      for key, capture in pairs(objects) do
        vim.keymap.set({ "x", "o" }, "a" .. key, function() select.select_textobject(capture .. ".outer", "textobjects") end, { desc = "Around " .. capture })
        vim.keymap.set({ "x", "o" }, "i" .. key, function() select.select_textobject(capture .. ".inner", "textobjects") end, { desc = "Inside " .. capture })
      end

      local function jump(fn, capture)
        return function() move[fn](capture, "textobjects") end
      end

      local function class_or_diff(fn, diff_key)
        return function()
          if vim.wo.diff then
            return diff_key
          end
          return ("<Cmd>lua require('nvim-treesitter-textobjects.move').%s('@class.outer', 'textobjects')<CR>"):format(fn)
        end
      end

      local nxo = { "n", "x", "o" }
      vim.keymap.set(nxo, "]f", jump("goto_next_start", "@function.outer"), { desc = "Next function start" })
      vim.keymap.set(nxo, "[f", jump("goto_previous_start", "@function.outer"), { desc = "Previous function start" })
      vim.keymap.set(nxo, "]F", jump("goto_next_end", "@function.outer"), { desc = "Next function end" })
      vim.keymap.set(nxo, "[F", jump("goto_previous_end", "@function.outer"), { desc = "Previous function end" })
      vim.keymap.set(nxo, "]c", class_or_diff("goto_next_start", "]c"), { expr = true, desc = "Next class (diff: next change)" })
      vim.keymap.set(nxo, "[c", class_or_diff("goto_previous_start", "[c"), { expr = true, desc = "Previous class (diff: prev change)" })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local map = function(mode, keys, fn, desc)
          vim.keymap.set(mode, keys, fn, { buffer = bufnr, desc = desc })
        end
        map("n", "]h", function() gs.nav_hunk("next") end, "Next git hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Previous git hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>gB", gs.blame, "Blame file")
        map("n", "<leader>gt", gs.toggle_current_line_blame, "Toggle inline blame")
        map("n", "<leader>gd", gs.diffthis, "Diff against index")
      end,
    },
  },
}

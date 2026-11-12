-- LSP: mason (installer) + mason-lspconfig (bridge) + native server config.
return {
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- One entry per server. Empty table = defaults.
      local servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=never",
          },
        },
        pyright = {},
      }

      -- Register configs (Neovim 0.11+ native LSP API). mason-lspconfig's
      -- automatic_enable then enables only the servers actually installed,
      -- so a missing binary never triggers a spawn error.
      for name, opts in pairs(servers) do
        opts.capabilities = capabilities
        vim.lsp.config(name, opts)
      end

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(ev)
          local tb = require("telescope.builtin")
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local map = function(keys, fn, desc, opts)
            vim.keymap.set("n", keys, fn, vim.tbl_extend("force", { buffer = ev.buf, desc = desc }, opts or {}))
          end

          map("gd", tb.lsp_definitions, "Goto definition")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")
          map("gr", tb.lsp_references, "References")
          map("grr", tb.lsp_references, "References")
          map("gi", tb.lsp_implementations, "Goto implementation")
          map("gri", tb.lsp_implementations, "Goto implementation")
          map("gy", tb.lsp_type_definitions, "Goto type definition")
          map("grt", tb.lsp_type_definitions, "Goto type definition")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<leader>ss", tb.lsp_document_symbols, "Document symbols")
          map("<leader>sS", tb.lsp_dynamic_workspace_symbols, "Workspace symbols")
          map("<leader>ci", tb.lsp_incoming_calls, "Incoming calls")
          map("<leader>co", tb.lsp_outgoing_calls, "Outgoing calls")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")

          if client and client.name == "clangd" then
            map("<leader>ch", "<cmd>LspClangdSwitchSourceHeader<CR>", "Switch source/header")
          end

          if client and client:supports_method("textDocument/documentHighlight", ev.buf) then
            local group = vim.api.nvim_create_augroup("UserLspHighlight" .. ev.buf, { clear = true })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              group = group,
              buffer = ev.buf,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
              group = group,
              buffer = ev.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("UserLspDetach", { clear = true }),
        callback = function(ev)
          vim.lsp.util.buf_clear_references(ev.buf)
          pcall(vim.api.nvim_del_augroup_by_name, "UserLspHighlight" .. ev.buf)
        end,
      })
    end,
  },
}

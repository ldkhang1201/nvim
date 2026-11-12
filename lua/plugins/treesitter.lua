return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main", -- Neovim 0.12 uses the rewritten Treesitter API.
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")
    -- Prefer the updated parsers over parsers left by the legacy plugin.
    treesitter.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })
    -- The current JSON grammar also handles comments in jsonc files.
    vim.treesitter.language.register("json", "jsonc")
    treesitter.install({
      "c", "cpp", "cuda", "python",
      "json", "lua", "markdown", "markdown_inline", "toml", "vim", "vimdoc",
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
      callback = function(event)
        local filetype = vim.bo[event.buf].filetype
        local lang = vim.treesitter.language.get_lang(filetype)
        if not lang then
          return
        end

        local function enable()
          if not vim.api.nvim_buf_is_valid(event.buf)
            or vim.bo[event.buf].filetype ~= filetype
            or not vim.treesitter.language.add(lang) then
            return
          end
          vim.treesitter.start(event.buf, lang)
          if vim.treesitter.query.get(lang, "indents") then
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end

        if vim.treesitter.language.add(lang) then
          enable()
        elseif require("nvim-treesitter.parsers")[lang] then
          -- Preserve automatic installation when opening another supported language.
          treesitter.install({ lang }):await(vim.schedule_wrap(function(err, success)
            if err then
              vim.notify(tostring(err), vim.log.levels.ERROR)
            elseif success then
              enable()
            end
          end))
        end
      end,
    })
  end,
}

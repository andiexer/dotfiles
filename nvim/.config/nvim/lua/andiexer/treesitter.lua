local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
 }
function M.config()
  require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "markdown", "markdown_inline", "bash", "python", "c_sharp", "yaml", "terraform", "sql" }, -- put the language you want in this array
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    indent = { enable = true },
  } 
end

return M

local M = {
  "Mofiqul/dracula.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  commit = "cadf9a1d873d67a92a76b258715cad91f0c1dbb9",
}

function M.config()
  vim.cmd.colorscheme "dracula"
end

return M

local M = {
  "ellisonleao/glow.nvim"
}

function M.config() 
  local keymap = vim.keymap.set
  keymap("n", "<leader>p", ":Glow<CR>", { noremap = true, silent = true })


  require("glow").setup({
    border = "rounded",
    style = "dark",
  })
end

return M

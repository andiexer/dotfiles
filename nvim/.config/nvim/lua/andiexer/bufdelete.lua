local M = {
  "famiu/bufdelete.nvim",
  event = "VeryLazy",
}

function M.config()
  local wk = require "which-key"

  wk.register {
    ["<leader>bc"] = { "<cmd>lua require('bufdelete').bufdelete(0, false)<CR>", "Close Buffer" }
  }
end

return M

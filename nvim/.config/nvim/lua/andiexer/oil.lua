local M = {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  }
}

function M.config()
  require("oil").setup {
    float = {
      max_height = 20,
      maxi_width = 80,
    }
  }

  vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open parent directory" })
end

return M

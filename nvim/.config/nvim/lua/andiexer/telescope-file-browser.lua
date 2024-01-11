local M = {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
}

function M.config()
  require("telescope").setup({
    extensions = {
      file_browser = {
        disable_devicons = false,
        show_hidden = true,
        width = 0.25,
        position = "left",
      },
    }
  })

  require("telescope").load_extension("file_browser")
end

return M

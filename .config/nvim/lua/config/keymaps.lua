-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "jj", "<ESC>", { silent = true })
vim.keymap.set("i", "jk", "<ESC>", { silent = true })
vim.keymap.set({ "n", "t" }, "<leader>tt", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Toggle Terminal" })

-- buffers
-- vim.api.nvim_set_keymap("n", "bk", ":blast<enter>", { noremap = false })
-- vim.api.nvim_set_keymap("n", "bj", ":bfirst<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "gt", ":bprev<enter>", { noremap = false })
vim.api.nvim_set_keymap("n", "gT", ":bnext<enter>", { noremap = false })

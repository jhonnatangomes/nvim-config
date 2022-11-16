local opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap("n", "<leader>do", ":DiffviewOpen<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>dc", ":DiffviewClose<CR>", opts)

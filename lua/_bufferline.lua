require("bufferline").setup{}
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>bcr", ":BufferLineCloseRight", opts)
vim.api.nvim_set_keymap("n", "<leader>bcl", ":BufferLineCloseLeft", opts)

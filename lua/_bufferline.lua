local ok, bufferline = pcall(require, "bufferline")
if not ok then
	return
end
bufferline.setup({
	options = {
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
	},
})
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>bcb", ":BufferLineCloseRight<CR> :BufferLineCloseLeft<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>bcr", ":BufferLineCloseRight<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>bcl", ":BufferLineCloseLeft<CR>", opts)

local ok, telescope = pcall(require, "telescope")
local ok2, builtin = pcall(require, "telescope.builtin")
if not ok or not ok2 then
	return
end
vim.keymap.set("n", "<leader>ff", builtin.find_files, {
	desc = "Find Files",
})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
	desc = "Find in Files",
})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {
	desc = "Find Buffers",
})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {
	desc = "Help Tags",
})

telescope.setup({
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
})

telescope.load_extension("fzf")

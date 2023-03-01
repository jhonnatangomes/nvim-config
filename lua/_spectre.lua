local spectre = require("spectre")
spectre.setup()
vim.keymap.set("n", "<leader>S", spectre.open, {
	desc = "Open Spectre",
})
vim.keymap.set("n", "<leader>sw", function()
	spectre.open_visual({ select_word = true })
end, {
	desc = "Open Spectre On Word",
})
vim.keymap.set("n", "<leader>s", spectre.open_visual, {
	desc = "Open Spectre Visual",
})

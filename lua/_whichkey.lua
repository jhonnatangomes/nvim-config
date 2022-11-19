local ok, whichkey = pcall(require, "which-key")
if not ok then
	return
end
whichkey.setup({})
whichkey.register({
	b = {
		name = "Bufferline",
		c = {
			name = "Close",
		},
	},
	c = {
		name = "Code Actions",
	},
	d = {
		name = "DiffView/Diagnostics",
	},
	f = {
		name = "File Search",
	},
	o = {
		name = "Organize Imports",
	},
	r = {
		name = "Rename",
	},
	w = {
		name = "Workspace",
	},
}, { prefix = "<leader>" })
whichkey.register({
	["["] = {
		name = "Previous jump",
	},
	["]"] = {
		name = "Next jump",
	},
	z = {
		name = "Fold",
	},
	g = {
		name = "Go",
	},
	["<leader>"] = {
		name = "Leader",
	},
})

local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local ok2, lspconfig = pcall(require, "lspconfig")
local ok5, typescript = pcall(require, "typescript")

if not ok or not ok2 or not ok3 or not ok4 or not ok5 then
	return
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = cmp_nvim_lsp.default_capabilities()

local createOpts = function(desc)
	local opts = { noremap = true, silent = true }
	return vim.tbl_extend("error", opts, { desc = desc })
end

local bufOptsFactory = function(bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	return function(desc)
		return vim.tbl_extend("error", bufopts, { desc = desc })
	end
end

local setKeymap = function(keymap, callback, opts)
	vim.keymap.set("n", keymap, callback, opts)
end

setKeymap("<space>df", vim.diagnostic.open_float, createOpts("Open Diagnostics Float"))
setKeymap("[d", vim.diagnostic.goto_prev, createOpts("Previous Diagnostic"))
setKeymap("]d", vim.diagnostic.goto_next, createOpts("Next Diagnostic"))
setKeymap("<space>q", vim.diagnostic.setloclist, createOpts("Add buffer diagnostics to location list"))

local on_attach = function(client, bufnr)
	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local createBufOpts = bufOptsFactory(bufnr)
	setKeymap("gD", vim.lsp.buf.declaration, createBufOpts("Go to declaration"))
	setKeymap("gd", vim.lsp.buf.definition, createBufOpts("Go to definition"))
	setKeymap("K", vim.lsp.buf.hover, createBufOpts("Hover"))
	setKeymap("gi", vim.lsp.buf.implementation, createBufOpts("Go To Implementation"))
	setKeymap("<C-k>", vim.lsp.buf.signature_help, createBufOpts("Show Signature Help"))
	setKeymap("<space>wa", vim.lsp.buf.add_workspace_folder, createBufOpts("Add Workspace Folder"))
	setKeymap("<space>wr", vim.lsp.buf.remove_workspace_folder, createBufOpts("Remove Workspace Folder"))
	setKeymap("<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, createBufOpts("List Workspace Folders"))
	setKeymap("<space>D", vim.lsp.buf.type_definition, createBufOpts("Go to Type Definition"))
	setKeymap("<space>rn", vim.lsp.buf.rename, createBufOpts("Rename Current File"))
	setKeymap("<leader>ca", vim.lsp.buf.code_action, createBufOpts("Code Action"))
	setKeymap("gr", vim.lsp.buf.references, createBufOpts("List Symbol References"))
	setKeymap("<leader>oi", typescript.actions.organizeImports, createBufOpts("Organize Imports"))
end

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { "html", "cssls", "jsonls", "clangd", "rust_analyzer", "gopls", "jdtls", "pyright" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		-- on_attach = my_custom_on_attach,
		capabilities = capabilities,
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		},
		single_file_support = true,
	})
end

-- local config = {
--     cmd = {'jdtls'},
--     root_dir = vim.fs.dirname(vim.fs.find({'.gradlew', '.git', 'mvnw'}, { upward = true })[1]),
-- }
-- require('jdtls').start_or_attach(config)

typescript.setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		},
		single_file_support = true,
	},
})

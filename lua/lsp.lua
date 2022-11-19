local fn = vim.fn

local tsserverExists = fn.executable("typescript-language-server")

if tsserverExists == 0 then
	print("Installing typescript language server. Please wait.")
	fn.system({
		"npm",
		"i",
		"-g",
		"typescript",
		"typescript-language-server",
	})
	print("Typescript language server installed")
end

local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local ok2, lspconfig = pcall(require, "lspconfig")
local ok3, luasnip = pcall(require, "luasnip")
local ok4, cmp = pcall(require, "cmp")

if not ok or not ok2 or not ok3 or not ok4 then
	return
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = cmp_nvim_lsp.default_capabilities()

local opts = { noremap = true, silent = true }
vim.keymap.set(
	"n",
	"<space>df",
	vim.diagnostic.open_float,
	{ noremap = true, silent = true, desc = "Open Diagnostics Float" }
)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { noremap = true, silent = true, desc = "Previous Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { noremap = true, silent = true, desc = "Next Diagnostic" })
vim.keymap.set(
	"n",
	"<space>q",
	vim.diagnostic.setloclist,
	{ noremap = true, silent = true, desc = "Add buffer diagnostics to location list" }
)

local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = "",
	}
	vim.lsp.buf.execute_command(params)
end

local on_attach = function(client, bufnr)
	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set(
		"n",
		"gD",
		vim.lsp.buf.declaration,
		{ noremap = true, silent = true, buffer = bufnr, desc = "Go to declaration" }
	)
	vim.keymap.set(
		"n",
		"gd",
		vim.lsp.buf.definition,
		{ noremap = true, silent = true, buffer = bufnr, desc = "Go to definition" }
	)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true, buffer = bufnr, desc = "Hover" })
	vim.keymap.set(
		"n",
		"gi",
		vim.lsp.buf.implementation,
		{ noremap = true, silent = true, buffer = bufnr, desc = "Go To Implementation" }
	)
	vim.keymap.set(
		"n",
		"<C-k>",
		vim.lsp.buf.signature_help,
		{ noremap = true, silent = true, buffer = bufnr, desc = "Show Signature Help" }
	)
	vim.keymap.set(
		"n",
		"<space>wa",
		vim.lsp.buf.add_workspace_folder,
		{ noremap = true, silent = true, buffer = bufnr, desc = "Add Workspace Folder" }
	)
	vim.keymap.set(
		"n",
		"<space>wr",
		vim.lsp.buf.remove_workspace_folder,
		{ noremap = true, silent = true, buffer = bufnr, desc = "Remove Workspace Folder" }
	)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, { noremap = true, silent = true, buffer = bufnr, desc = "List Workspace Folders" })
	vim.keymap.set(
		"n",
		"<space>D",
		vim.lsp.buf.type_definition,
		{ noremap = true, silent = true, buffer = bufnr, desc = "Go to Type definition" }
	)
	vim.keymap.set(
		"n",
		"<space>rn",
		vim.lsp.buf.rename,
		{ noremap = true, silent = true, buffer = bufnr, desc = "Rename Current File" }
	)
	vim.keymap.set(
		"n",
		"<leader>ca",
		vim.lsp.buf.code_action,
		{ noremap = true, silent = true, buffer = bufnr, desc = "Code Action" }
	)
	vim.keymap.set(
		"n",
		"gr",
		vim.lsp.buf.references,
		{ noremap = true, silent = true, buffer = bufnr, desc = "List Symbol References" }
	)
	vim.keymap.set(
		"n",
		"<leader>oi",
		organize_imports,
		{ noremap = true, silent = true, buffer = bufnr, desc = "Organize Imports" }
	)
end

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { "tsserver" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		-- on_attach = my_custom_on_attach,
		capabilities = capabilities,
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
		},
		commands = {
			OrganizeImports = {
				organize_imports,
				description = "Organize Imports",
			},
		},
	})
end

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})

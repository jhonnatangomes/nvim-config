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
local ok5, typescript = pcall(require, "typescript")

if not ok or not ok2 or not ok3 or not ok4 or not ok5 then
	return
end

require("luasnip.loaders.from_vscode").lazy_load()

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

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
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
			elseif has_words_before() then
				cmp.complete()
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
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
	}),
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

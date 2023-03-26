local ok, null_ls = pcall(require, "null-ls")
local ok2, ts_code_actions = pcall(require, "typescript.extensions.null-ls.code-actions")
if not ok or not ok2 then
	return
end
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local null_ls_utils = require("null-ls.utils")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						bufnr = bufnr,
						filter = function(client)
							return client.name == "null-ls"
						end,
					})
				end,
			})
		end
	end,
	sources = {
		formatting.prettier.with({
			command = "prettier",
			dynamic_command = function(params)
				local root = null_ls_utils.get_root()
				local dir = null_ls_utils.path.join(root, "node_modules", ".bin")
				local dir_exists = vim.fn.isdirectory(dir) ~= 0
				if dir_exists then
					return null_ls_utils.path.join(dir, params.command)
				end
				return params.command
			end,
			extra_args = { "--single-quote" },
		}),
		diagnostics.eslint_d.with({
			condition = function(utils)
				return utils.root_has_file({ ".eslintrc.js", ".eslintrc.json" })
			end,
		}),
		diagnostics.flake8,
		formatting.stylua,
		formatting.clang_format,
		formatting.gofmt,
		ts_code_actions,
		formatting.rustfmt,
		formatting.sql_formatter,
	},
})

local notify = vim.notify
vim.notify = function(msg, ...)
	if msg:match("warning: multiple different client offset_encodings") then
		return
	end
	notify(msg, ...)
end

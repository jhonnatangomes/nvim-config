local fn = vim.fn
local prettierExists = fn.executable("prettier")
local eslintExists = fn.executable("eslint")

if prettierExists == 0 then
	print("Installing prettier. Please wait")
	fn.system({
		"npm",
		"i",
		"-g",
		"prettier",
	})
	print("Prettier installed.")
end

if eslintExists == 0 then
	print("Installing eslint. Please wait")
	fn.system({
		"npm",
		"i",
		"-g",
		"eslint",
	})
	print("Eslint installed.")
end

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
				return null_ls_utils.path.join(root, "node_modules", ".bin", params.command) or params.command
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

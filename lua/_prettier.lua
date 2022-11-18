local fn = vim.fn
local prettierExists = fn.executable('prettier');
local eslintExists = fn.executable('eslint');

if prettierExists == 0 then
  fn.system {
    'npm',
    'i',
    '-g', 
    'prettier', 
  }
  print "Installing prettier"
end

if eslintExists == 0 then
  fn.system {
    'npm',
    'i',
    '-g', 
    'eslint', 
  }
  print "Installing eslint"
end

local ok, null_ls = pcall(require, "null-ls")
if not ok then 
  return 
end
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function ()
          vim.lsp.buf.format({
            bufnr = bufnr,
            filter = function(client)
              return client.name == "null-ls"
            end
          })
        end,
      })
    end
  end,
  sources = {
    formatting.prettier.with {
      extra_args = {"--single-quote"}
    },
    diagnostics.eslint
  }
})



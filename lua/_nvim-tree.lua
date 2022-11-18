vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
local ok, nvim_tree = pcall(require, 'nvim-tree')
if not ok then
  return
end
nvim_tree.setup()


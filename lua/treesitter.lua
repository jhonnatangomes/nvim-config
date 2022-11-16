require 'nvim-treesitter.configs'.setup {
  ensure_installed = {"javascript", "typescript"},
  auto_install = true,
  highlight = {
    enable = true,
  }
}

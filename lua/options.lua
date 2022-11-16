local options = {
  backup = false,                          
  clipboard = "unnamedplus",               
  cmdheight = 2,                           
  completeopt = { "menuone", "noselect" }, 
  conceallevel = 0,                        
  ignorecase = true,                       
  mouse = "a",                             
  pumheight = 10,                          
  showtabline = 2,                         
  smartcase = true,                        
  smartindent = true,                      
  splitbelow = true,                       
  splitright = true,                       
  swapfile = false,                        
  timeoutlen = 1000,                       
  undofile = true,                         
  updatetime = 300,                        
  writebackup = false,                     
  expandtab = true,                        
  shiftwidth = 2,                          
  tabstop = 2,                             
  number = true,                           
  numberwidth = 4,                         
  signcolumn = "yes",                      
  wrap = false,                            
  scrolloff = 8,                           
  sidescrolloff = 8,
  showmode = false,
} 

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.laststatus = 3
vim.opt.splitkeep = "screen"

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.fixendofline = true

vim.opt.list = true
vim.opt.listchars = { tab = ">.", trail = "_" }

vim.g.python_indent = {
  closed_paren_align_last_line = false,
  open_paren = "shiftwidth()",
}

vim.diagnostic.config({
  float = {
    source = "always",
    border = "rounded",
  },
  severity_sort = true
})

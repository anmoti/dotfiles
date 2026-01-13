require("config.lazy")
require("config.autocmd")

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.filetype.add({
  pattern = {
    [".*config/sway/config.*"] = "swayconfig",
    [".*config/kitty/.*%.conf"] = "kitty",
  },
})

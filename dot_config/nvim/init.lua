require("config.lazy")

vim.cmd.colorscheme "catppuccin-mocha"

vim.filetype.add({
  pattern = {
    [".*dot_zshrc"]		= "zsh",
    [".*config/sway/config.*"]	= "swayconfig",
    [".*config/kitty/.*%.conf"]	= "kitty",
  },
})

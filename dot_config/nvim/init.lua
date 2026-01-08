require("config.lazy")

vim.cmd.colorscheme "catppuccin-mocha"

vim.filetype.add({
  pattern = {
    -- for sway
    [".*/sway/config.*"] = "swayconfig",

    -- for kitty
    [".*/kitty/.*%.conf"] = "kitty",
  },
})

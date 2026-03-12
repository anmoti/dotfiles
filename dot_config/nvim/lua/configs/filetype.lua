vim.filetype.add({
  pattern = {
    [".*%.gtk%.css"] = "css.gtk",
    [".*config/sway/config.*"] = "swayconfig",
    [".*config/kitty/.*%.conf"] = "kitty",
  },
})

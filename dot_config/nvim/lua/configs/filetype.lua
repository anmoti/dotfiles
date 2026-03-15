vim.filetype.add({
  extension = {
    tf = "terraform",
  },
  pattern = {
    [".*%.gtk%.css"] = "css.gtk",
    [".*config/sway/config.*"] = "swayconfig",
    [".*config/kitty/.*%.conf"] = "kitty",
  },
})

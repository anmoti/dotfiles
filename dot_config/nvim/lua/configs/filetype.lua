vim.filetype.add({
  pattern = {
    [".*config/sway/config.*"] = "swayconfig",
    [".*config/kitty/.*%.conf"] = "kitty",
  },
})

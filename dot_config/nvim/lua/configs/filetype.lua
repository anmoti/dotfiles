vim.filetype.add({
  extension = {
    tf = "terraform",
    tofu = "opentofu",
    tfvars = "opentofu-vars",
  },
  pattern = {
    [".*%.gtk%.css"] = "css.gtk",
    [".*config/sway/config.*"] = "swayconfig",
    [".*config/kitty/.*%.conf"] = "kitty",
    [".*compose%.ya?ml"] = "yaml.docker-compose",
  },
})

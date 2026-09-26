vim.filetype.add({
  extension = {
    tf = "terraform",
    tofu = "opentofu",
    tfvars = "opentofu-vars",
  },
  filename = {
    ['buf.yaml'] = 'buf-config',
    ['buf.gen.yaml'] = 'buf-config',
    ['buf.policy.yaml'] = 'buf-config',
    ['buf.lock'] = 'buf-config',
  },
  pattern = {
    [".*%.gtk%.css"] = "css.gtk",
    [".*config/sway/config.*"] = "swayconfig",
    [".*config/kitty/.*%.conf"] = "kitty",
    [".*compose%.ya?ml"] = "yaml.docker-compose",
  },
})

vim.treesitter.language.register('yaml', 'buf-config')

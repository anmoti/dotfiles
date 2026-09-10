---@module "lazy"
---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          filetypes = { "bash", "sh", "zsh" },
        },
      },
    },
  },
}

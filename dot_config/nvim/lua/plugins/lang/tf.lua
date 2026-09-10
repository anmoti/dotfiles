---@module "lazy"
---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tofu_ls = {},
      },
    },
  },
}

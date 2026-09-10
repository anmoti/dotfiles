---@module "lazy"
---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        taplo = {
          -- taplo has built-in support for schema store.
        },
      },
    },
  },
}

---@module "lazy"
---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              diagnostics = {
                enable = true,
              },
            },
          },
        },
      },
    },
  },
}

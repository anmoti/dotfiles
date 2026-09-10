---@module "lazy"
---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {}, -- vscode-langservers-extracted
      },
    },
  },
}

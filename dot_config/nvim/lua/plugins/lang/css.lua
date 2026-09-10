---@module "lazy"
---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {}, -- vscode-langservers-extracted
        gtkcssls = {
          cmd = { "gtk-css-language-server" },
          filetypes = { "css.gtk" }
        },
      },
    },
  },
}

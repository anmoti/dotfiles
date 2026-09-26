---@module "lazy"
---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    ---@type LspConfigOpts
    opts = {
      servers = {
        svelte = {},
        astro = {},
        tailwindcss = {},
      },
    },
  }
}

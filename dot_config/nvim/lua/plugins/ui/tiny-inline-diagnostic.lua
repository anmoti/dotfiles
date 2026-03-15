---@module "lazy"
---@type LazySpec
return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      preset = "modern",
      options = {
        multilines = {
          enabled = true,
        },
      },
    },
  },
}

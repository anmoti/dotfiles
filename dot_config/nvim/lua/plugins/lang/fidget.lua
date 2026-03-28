---@module "lazy"
---@type LazySpec
return {
  {
    "j-hui/fidget.nvim",
    opts = {
      progress = {
        display = {
          render_limit = 32,
          done_ttl = 6,
        },
      },
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },
}

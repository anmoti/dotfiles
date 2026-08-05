---@module "lazy"
---@type LazySpec
return {
  {
    "one-d-wide/lazy-patcher.nvim",
    ft = "lazy",
    opts = {
      patches_path = vim.fn.stdpath("config") .. "/patches",
    },
  },
}

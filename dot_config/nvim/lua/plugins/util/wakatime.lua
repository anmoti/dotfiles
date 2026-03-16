---@module "lazy"
---@type LazySpec
return {
  {
    "wakatime/vim-wakatime",
    lazy = false,
    ---@module "wakatime"
    ---@type wakatime.Config
    opts = {},
  }
}

---@module "lazy"
---@type LazySpec
return {
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {
      check_ts = true,
    },
  },
}

---@module "lazy"
---@type LazySpec
return {
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    opts = {},
    keys = {
      { "<leader>lv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
    },
  }
}

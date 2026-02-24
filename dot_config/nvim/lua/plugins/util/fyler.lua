return {
  {
    "A7Lavinraj/fyler.nvim",
    dependencies = { "nvim-mini/mini.icons" },
    lazy = false,
    ---@module "fyler"
    ---@type FylerSetup
    opts = {
      integrations = {
        icon = "mini_icons",
      },
      views = {
        ---@diagnostic disable: missing-fields
        finder = {
          default_explorer = true,
          close_on_select = false,
          watcher = {
            enabled = true,
          },
          win = { kind = "float", },
        },
      },
    },
    keys = {
      { "<leader>e", "<Cmd>Fyler<Cr>", desc = "Open Fyler view" },
    },
  },
}

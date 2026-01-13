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
          win = {
            kind = "split_left",
            kinds = {
              split_left = {
                width = "30",
              },
            },
          },
        },
      },
    },
    keys = {
      { "<leader>e", "<Cmd>Fyler<Cr>", desc = "Open Fyler view" },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
    },
  },
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "sa",
        delete = "sd",
        replace = "sr",
      },
    },
  },
}

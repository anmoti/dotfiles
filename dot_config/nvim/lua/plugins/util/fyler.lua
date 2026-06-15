return {
  {
    "FylerOrg/fyler.nvim",
    dependencies = { "nvim-mini/mini.icons" },
    lazy = false,
    ---@module "fyler"
    ---@type fyler.UserConfig
    opts = {
      integrations = {
        icon = "mini_icons",
      },
      use_as_default_explorer = true,
      kind = "floating",
      kind_presets = {
        floating = {
          mappings = {
            n = {
              ["<CR>"] = { action = "select", args = { close = false } },
            },
          },
        },
      },
    },
    keys = {
      { "<leader>e", "<Cmd>Fyler<Cr>", desc = "Open Fyler view" },
    },
  },
}

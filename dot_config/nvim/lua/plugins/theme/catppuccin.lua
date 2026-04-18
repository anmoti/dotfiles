return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    ---@module "catppuccin"
    ---@type CatppuccinOptions
    opts = {
      flavour = "mocha",
      transparent_background = true,
      custom_highlights = function(colors)
        return {
          LineNr = { fg = colors.overlay1 },
          CursorLineNr = { fg = colors.peach },

          LspInlayHint = {
            fg = colors.overlay1,
            bg = colors.surface0,
            style = { "italic" },
          },

          SnacksIndent1 = { fg = colors.red },
          SnacksIndent3 = { fg = colors.peach },
          SnacksIndent4 = { fg = colors.yellow },
          SnacksIndent5 = { fg = colors.green },
          SnacksIndent6 = { fg = colors.sky },
          SnacksIndent7 = { fg = colors.blue },
          SnacksIndent8 = { fg = colors.mauve },
        }
      end,
      auto_integrations = true,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")

      vim.api.nvim_set_hl(0, "SnacksExplorer", { bg = "NONE" })
    end,
  },
}

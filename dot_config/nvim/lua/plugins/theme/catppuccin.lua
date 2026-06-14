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

          Whitespace = { bg = colors.red },

          LspInlayHint = {
            fg = colors.overlay1,
            bg = colors.surface0,
            style = { "italic" },
          },

          -- https://github.com/catppuccin/catppuccin/blob/main/docs/style-guide.md
          -- Rainbow order: Red, Peach, Yellow, Green, Sapphire, Lavender
          SnacksIndent1 = { fg = colors.red },
          SnacksIndent2 = { fg = colors.peach },
          SnacksIndent3 = { fg = colors.yellow },
          SnacksIndent4 = { fg = colors.green },
          SnacksIndent5 = { fg = colors.sapphire },
          SnacksIndent6 = { fg = colors.lavender },
          SnacksIndent7 = { fg = colors.teal },
          SnacksIndent8 = { fg = colors.blue },
        }
      end,
      auto_integrations = true,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}

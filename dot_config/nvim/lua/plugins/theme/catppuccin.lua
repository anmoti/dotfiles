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

          -- https://github.com/mrjones2014/codecompanion-ui.nvim/blob/master/lua/codecompanion-ui/init.lua#L21
          CcuiTitle = { fg = colors.base, bg = colors.blue },
          CcuiMode = { fg = colors.base, bg = colors.blue },

          -- gitsigns.nvim: catppuccin's default GitSignsAdd (green) was hard to tell
          -- apart from GitSignsChange (yellow) in the thin signcolumn glyph, so Add
          -- moved to teal to match FylerGitUntracked below. Change stays yellow.
          GitSignsAdd = { fg = colors.teal },
          GitSignsAddPreview = { fg = colors.teal },
          GitSignsAddInline = { fg = colors.base, bg = colors.teal, style = { "bold" } },

          -- fyler.nvim git extension (no official catppuccin integration; follows
          -- the file-status convention from catppuccin's own diffview.nvim integration).
          -- blue is reserved for FylerDirectoryName/Icon. Staged vs. unstaged must be
          -- visually distinct, so staged (index) is green and unstaged modified is yellow.
          FylerGitModified = { fg = colors.yellow },
          FylerGitStaged = { fg = colors.green },
          FylerGitUntracked = { fg = colors.teal },
          FylerGitDeleted = { fg = colors.red },
          FylerGitRenamed = { fg = colors.yellow },
          FylerGitConflict = { fg = colors.yellow },
          FylerGitIgnored = { fg = colors.overlay0 },
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

---@module "lazy"
---@type LazySpec
return {
  {
    "folke/which-key.nvim",
    dependencies = { "nvim-mini/mini.icons" },
    event = "VeryLazy",
    ---@module "which-key"
    ---@type wk.Opts
    opts = {
      preset = "helix",
      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>l", group = "Code: LSP/Language" },
      },
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true, -- z= でスペルチェック候補を出す
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,      -- 移動キーのヒント
          text_objects = true, -- iw(内部単語) などのヒント
          windows = true,      -- <C-w> (ウィンドウ操作) のヒント
          nav = true,          -- ページ移動などのヒント
          z = true,            -- z から始まるコマンド（折り畳みなど）
          g = true,            -- g から始まるコマンド（定義ジャンプなど）
        },
      },
      icons = {
        rules = {
          { pattern = "fyler", icon = " ", color = "purple" },
        },
      },
    },
    keys = {
      {
        "<leader><leader>",
        function()
          require("which-key").show()
        end,
        desc = "Show all keymaps",
      },
    },
  },
}

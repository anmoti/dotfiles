return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    ---@module "which-key"
    ---@type wk.Opts
    opts = {
      preset = "helix",
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
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@module "flash"
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      user_default_options = {
        names = true,
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        oklch_fn = true,
        tailwind = true,
        background = true,
      },
    },
  },
}

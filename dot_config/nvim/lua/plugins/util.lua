return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
      toggle = {
        enabled = true,
        which_key = true,
      },
      picker = {
        enabled = true,
      },
      notifier = {
        enabled = true,
      },
      input = {
        enabled = true,
      },
    },
    keys = {
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
    },
  },
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
          motions = true, -- 移動キーのヒント
          text_objects = true, -- iw(内部単語) などのヒント
          windows = true, -- <C-w> (ウィンドウ操作) のヒント
          nav = true, -- ページ移動などのヒント
          z = true, -- z から始まるコマンド（折り畳みなど）
          g = true, -- g から始まるコマンド（定義ジャンプなど）
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

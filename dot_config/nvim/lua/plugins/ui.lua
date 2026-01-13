return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      auto_integrations = true,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-mini/mini.icons" },
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<Cr>", desc = "Next buffer" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<Cr>", desc = "Prev buffer" },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<Cr>", desc = "Toggle Pin" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<Cr>", desc = "Delete Other Buffers" },
    },
    ---@module "bufferline"
    ---@type bufferline.UserConfig
    opts = {
      options = {
        separator = "slant",
        always_show_bufferline = true,

        show_buffer_icons = true,
        show_buffer_close_icons = true,

        diagnostics = "nvim_lsp",

        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
      },
    },
  },
}

---@module "lazy"
---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    ---@type LspConfigOpts
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              -- workspace = {
              --   library = vim.api.nvim_get_runtime_file("", true),
              -- },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
  {
    "folke/lazydev.nvim",
    dependencies = {
      "Bilal2453/luvit-meta",
    },
    ft = "lua",
    ---@module "lazydev"
    ---@type lazydev.Config
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "saghen/blink.cmp",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      sources = {
        providers = {
          lazydev = {
            name = "lazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
    },
  },
}

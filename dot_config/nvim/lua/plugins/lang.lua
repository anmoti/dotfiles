return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
  },
  {
    "saghen/blink.cmp",
    version = "*",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "super-tab",
      },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "lazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
    },
    opts_extend = { "sources.default" },
  },
  { "Bilal2453/luvit-meta", lazy = true },
  {
    "folke/lazydev.nvim",
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
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").setup()

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter-setup", {}),
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
  {
    --https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
    },
    opts = {
      servers = {
        bashls = {
          filetypes = { "bash", "sh", "zsh" },
        },
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
        html = {}, -- vscode-langservers-extracted
        gtkcssls = {
          cmd = { "gtk-css-language-server" },
          filetypes = { "css.gtk" }
        },
        cssls = {},  -- vscode-langservers-extracted
        jsonls = {}, -- vscode-langservers-extracted
        nixd = {
          settings = {
            nixd = {
              nixpkgs = {
                expr = "import <nixpkgs> { }",
              },
              formatting = {
                command = { "nixfmt" },
              },
              options = {
                home_manager = {
                  expr = '(builtins.getFlake (toString ./.)).homeConfigurations.' .. os.getenv("USER") .. '.options',
                },
              },
            },
          },

        },
        terraformls = {},
      },
    },
    config = function(_, opts)
      for server, server_opts in pairs(opts.servers) do
        server_opts.capabilities = require("blink.cmp").get_lsp_capabilities(server_opts.capabilities)
        vim.lsp.config(server, server_opts)
        vim.lsp.enable(server)
      end
    end,
  },
}

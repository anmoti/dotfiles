return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = {
          "ruff_fix", "ruff_format", "ruff_organize_imports",
        },
      },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
  },
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = { "fang2hou/blink-copilot" },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "super-tab",
      },
      sources = {
        default = { "lazydev", "lsp", "copilot", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "lazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "rounded",
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
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = {
      code = {
        sign = false,
        width = "block",
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("render-markdown-setup", {}),
        pattern = "markdown",
        callback = function()
          pcall(require("render-markdown").enable)
        end
      })
    end,
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
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "off",
              },
            },
          },
        },
        ruff = {
          config = function(opt)
            -- https://docs.astral.sh/ruff/ditors/setup/#neovim
            opt.on_attach(function(client)
              -- LSP: Disable hover capability from Ruff
              client.server_capabilities.hoverProvider = false
            end)

            opt.enable()
          end,
        },
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
        local user_config = server_opts.config
        server_opts.config = nil

        server_opts.capabilities = require("blink.cmp").get_lsp_capabilities(server_opts.capabilities)

        local opt = {
          enable = function()
            vim.lsp.config(server, server_opts)
            vim.lsp.enable(server)
          end,
          on_attach = function(fn)
            vim.api.nvim_create_autocmd("LspAttach", {
              callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.name == server then
                  fn(client, args)
                end
              end,
            })
          end,
          server = server,
          opts = server_opts,
        }

        if user_config then
          user_config(opt)
        else
          opt.enable()
        end
      end
    end,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      -- https://github.com/MartinLwx/dotfiles/blob/864e4b6/nvim/lua/plugins/nvim-lint.lua
      local lint = require("lint")

      lint.linters_by_ft = {
        python = { "mypy" },
      }

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}

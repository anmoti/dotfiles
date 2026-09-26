---@module "lazy"
---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                diagnosticMode = "workspace",
                inlayHints = {
                  variableTypes = true,
                  callArgumentNames = true,
                  callArgumentNamesMatching = false,
                  functionReturnTypes = true,
                  genericTypes = false,
                },
              },
            },
          },
        },
        ruff = {
          -- https://docs.astral.sh/ruff/editors/setup/#neovim
          on_attach = function(client)
            -- LSP: Disable hover capability from Ruff
            client.server_capabilities.hoverProvider = false
          end,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = {
          "ruff_fix",
          "ruff_format",
          "ruff_organize_imports",
        },
      },
    },
  },
  -- {
  --   "mfussenegger/nvim-lint",
  --   config = function()
  --     -- https://github.com/MartinLwx/dotfiles/blob/864e4b6/nvim/lua/plugins/nvim-lint.lua
  --     local lint = require("lint")
  --
  --     lint.linters_by_ft = {
  --       python = { "mypy" },
  --     }
  --
  --     vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
  --       group = vim.api.nvim_create_augroup("nvim-lint-setup", { clear = true }),
  --       callback = function()
  --         lint.try_lint()
  --       end,
  --     })
  --   end,
  -- },
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    opts = {},
    keys = {
      { "<leader>lv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
    },
  }
}

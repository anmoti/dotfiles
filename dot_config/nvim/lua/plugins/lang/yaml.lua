---@module "lazy"
---@type LazySpec
return {
  { "b0o/schemastore.nvim" },
  {
    "neovim/nvim-lspconfig",
    ---@type LspConfigOpts
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
            },
          },
          setup = function (opts)
            local schemastore = require("schemastore")
            opts.settings.yaml.schemas = schemastore.yaml.schemas()
          end,
        }, -- yaml-language-server
      },
    },
  },
}

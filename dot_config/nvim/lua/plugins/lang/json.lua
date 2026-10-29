local deps = {
  bin = {
    { "vscode-json-language-server", nix = "vscode-langservers-extracted" },
  },
}

if not require("utils.guard").check(deps) then
  return {}
end

---@module "lazy"
---@type LazySpec
return {
  { "b0o/schemastore.nvim" },
  {
    "neovim/nvim-lspconfig",
    ---@type LspConfigOpts
    opts = {
      servers = {
        jsonls = {
          settings = {
            json = {
              validate = {
                enable = true,
              },
            },
          },
          setup = function (opts)
            local schemastore = require("schemastore")
            opts.settings.json.schemas = schemastore.json.schemas()
          end,
        }, -- vscode-langservers-extracted
      },
    },
  },
}

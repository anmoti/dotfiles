local deps = {
  bin = {
    { "tsgo", nix = "typescript-go" },
  },
}

if not require("utils.guard").check(deps) then
  return {}
end

---@module "lazy"
---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    ---@type LspConfigOpts
    opts = {
      servers = {
        tsc = {
          settings = {
            ["js/ts"] = {
              inlayHints = {
                enabled = true,
                parameterNames = {
                  enabled = "literals",
                  suppressWhenArgumentMatchesName = true,
                },
                parameterTypes = { enabled = false },
                variableTypes = {
                  enabled = false,
                  suppressWhenExpressionIsLiteral = true,
                },
                propertyDeclarationTypes = { enabled = false },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
          },
        },
      },
    },
  }
}

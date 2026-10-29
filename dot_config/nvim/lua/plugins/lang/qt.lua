local deps = {
  bin = {
    { "qmlls", nix = "kdePackages.qtdeclarative" },
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
    opts = {
      servers = {
        qmlls = {},
      },
    },
  },
}

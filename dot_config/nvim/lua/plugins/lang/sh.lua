local deps = {
  bin = {
    { "shuck", nix = "local.shuck" },
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
        shuck = {},
      },
    },
  },
}

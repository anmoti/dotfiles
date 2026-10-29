local deps = {
  bin = {
    { "taplo", nix = "taplo" },
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
        taplo = {
          -- taplo has built-in support for schema store.
        },
      },
    },
  },
}

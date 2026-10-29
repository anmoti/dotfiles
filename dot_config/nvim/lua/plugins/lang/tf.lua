local deps = {
  bin = {
    { "tofu", nix = "opentofu" }, -- tofu_ls (schema, format)
    { "tofu-ls", nix = "tofu-ls" },
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
        tofu_ls = {},
      },
    },
  },
}

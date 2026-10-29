local deps = {
  bin = {
    { "buf", nix = "buf" },
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
        buf_ls = {},
      },
    },
  }
}

local deps = {
  bin = {
    { "go", proto = "go" },
    { "gopls", nix = "gopls" },
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
        gopls = {
          ---@module "lspconfig"
          ---@type lspconfig.settings.gopls
          settings = {
            go = {},
            gopls = {},
          }
        }
      }
    },
  },
  {
    "pcolladosoto/tinygo.nvim",
    cmd = { "TinyGoSetTarget", "TinyGoTargets", "TinyGoEnv" },
    opts = {},
  },
}

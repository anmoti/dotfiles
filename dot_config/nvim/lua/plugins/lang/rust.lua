local deps = {
  bin = {
    { "cargo", proto = "rust" },
    { "rustc", proto = "rust" },
    { "rust-analyzer", nix = "rustup" },
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
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              diagnostics = {
                enable = true,
              },
            },
          },
        },
      },
    },
  },
}

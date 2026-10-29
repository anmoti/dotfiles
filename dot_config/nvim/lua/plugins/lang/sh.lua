local deps = {
  bin = {
    { "bash-language-server", nix = "bash-language-server" },
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
        bashls = {
          filetypes = { "bash", "sh", "zsh" },
        },
      },
    },
  },
}

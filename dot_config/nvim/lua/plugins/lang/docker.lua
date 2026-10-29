local deps = {
  bin = {
    { "docker-language-server", nix = "docker-language-server" },
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
        docker_language_server = {},
      },
    },
  },
}

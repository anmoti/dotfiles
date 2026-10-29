local deps = {
  bin = {
    { "vscode-html-language-server", nix = "vscode-langservers-extracted" },
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
        html = {}, -- vscode-langservers-extracted
      },
    },
  },
}

local deps = {
  bin = {
    { "vscode-css-language-server", nix = "local.vscode-css-language-server" },
    { "gtk-css-language-server", nix = "local.gtk-css-language-server" },
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
        cssls = {}, -- vscode-langservers-extracted
        gtkcssls = {
          cmd = { "gtk-css-language-server" },
          filetypes = { "css.gtk" }
        },
      },
    },
  },
}

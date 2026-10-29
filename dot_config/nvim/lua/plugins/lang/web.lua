local deps = {
  bin = {
    { "node", proto = "node" },
    { "svelteserver", nix = "svelte-language-server" },
    { "astro-ls", nix = "unstable.astro-language-server" },
    { "tailwindcss-language-server", nix = "tailwindcss-language-server" },
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
        svelte = {},
        astro = {},
        tailwindcss = {},
      },
    },
  }
}

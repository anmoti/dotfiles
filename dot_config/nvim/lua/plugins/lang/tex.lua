local deps = {
  bin = {
    { "sioyek", nix = "sioyek" },
    { "latexmk", nix = "local.texlive" },
    { "biber", nix = "local.texlive" },
  },
}

if not require("utils.guard").check(deps) then
  return {}
end

---@module "lazy"
---@type LazySpec
return {
  {
    "lervag/vimtex",
    lazy = false, -- VimTeXは独自に遅延読み込みするのでこのままでいい
    init = function()
      vim.g.vimtex_view_method = "sioyek"
      vim.g.vimtex_compiler_method = "latexmk"
    end
  },
}

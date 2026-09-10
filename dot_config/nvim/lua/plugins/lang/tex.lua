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

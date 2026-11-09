local deps = {
  bin = {
    { "chezmoi", nix = "unstable.chezmoi" },
  },
}
if not require("utils.guard").check(deps) then
  return {}
end

return {
  {
    "dpezto/chezmoi-template.nvim",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ---@module "chezmoi-template"
    ---@type chezmoi-template.Config
    opts = {
      apply = {
        on_save = false, -- worktree overlay運用のため手動applyにする
      },
      inject = {
        enabled = true,
      },
    },
  },
  {
    "saghen/blink.cmp",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      sources = {
        providers = {
          chezmoi = {
            name = "chezmoi",
            module = "chezmoi-template.blink",
          },
        },
      },
    },
  },
}

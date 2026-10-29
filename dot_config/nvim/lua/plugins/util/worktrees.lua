local deps = {
  bin = {
    { "git", nix = "git" },
  },
}
if not require("utils.guard").check(deps) then
  return {}
end

---@module "lazy"
---@type LazySpec
return {
  {
    "afonsofrancof/worktrees.nvim",
    opts = {},
    keys = {
      {
        "<leader>gw",
        function()
          -- change_root = true → `:cd` でセッション全体のカレントを移動する
          require("worktrees").switch(true)
        end,
        desc = "Worktrees",
      },
    },
  },
}

local deps = {
  bin = {
    { "wakatime-cli", nix = "unstable.wakatime-cli" },
  },
}
if not require("utils.guard").check(deps) then
  return {}
end

---@module "lazy"
---@type LazySpec
return {
  {
    "wakatime/vim-wakatime",
    lazy = false,
    ---@module "wakatime"
    ---@type wakatime.Config
    opts = {},
  }
}

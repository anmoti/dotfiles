---@module "lazy"
---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nixd = {
          -- nixd evaluates the flake's pkgs; nixos-26.05's pnpm_10 is marked insecure and aborts that evaluation.
          cmd_env = { NIXPKGS_ALLOW_INSECURE = "1" },
          settings = {
            nixd = {},
          },
        },
      },
    },
  },
}

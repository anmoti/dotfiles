local hm_user = vim.env.USER or os.getenv("USER")

---@module "lazy"
---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nixd = {
          settings = {
            nixd = {
              nixpkgs = {
                expr = "import <nixpkgs> { }",
              },
              formatting = {
                command = { "nixfmt" },
              },
              options = {
                home_manager = {
                  expr = '(builtins.getFlake (toString ./.)).homeConfigurations.' .. hm_user .. '.options',
                },
              },
            },
          },
        },
      },
    },
  },
}

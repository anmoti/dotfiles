---@module "lazy"
---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = false, -- parsers are installed via home-manager (pkgs.vimPlugins.nvim-treesitter.withAllGrammars)
    lazy = false,
    config = function()
      require("nvim-treesitter").setup()

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter-setup", {}),
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}

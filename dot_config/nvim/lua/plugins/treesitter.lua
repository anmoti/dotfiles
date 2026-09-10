---@module "lazy"
---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = false, -- parsers are installed via home-manager (pkgs.vimPlugins.nvim-treesitter.withAllGrammars)
    lazy = false,
    config = function(plugin)
      -- nvim-treesitter main branch stores queries under runtime/, not the plugin root.
      -- Add it to rtp so that vim.treesitter can find highlights.scm etc.
      vim.opt.rtp:prepend(plugin.dir .. "/runtime")

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

---@module "lazy"
---@type LazySpec
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = {
      code = {
        sign = false,
        width = "block",
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("render-markdown-setup", {}),
        pattern = "markdown",
        callback = function()
          pcall(require("render-markdown").enable)
        end
      })
    end,
  },
}

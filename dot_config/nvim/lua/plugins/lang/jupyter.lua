local deps = {
  lang = { "python" },
  bin = {
    { "tree-sitter", nix = "tree-sitter" }, -- ipynb.nvim (tree-sitter build)
    { "cc", nix = "gcc" }, -- ipynb.nvim (tree-sitter build)
  },
}
if not require("utils.guard").check(deps) then
  return {}
end

---@module "lazy"
---@type LazySpec
return {
  {
    "ajbucci/ipynb.nvim",
    -- setup() registers BufReadCmd/BufWriteCmd for *.ipynb, so load right before the first one is opened
    event = { "BufReadCmd *.ipynb", "BufNewFile *.ipynb" },
    -- other :Notebook* commands are buffer-local and only exist once a notebook is open
    cmd = { "NotebookCreate", "NotebookListKernels" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
    },
    opts = {
      -- put the shadow file in the project so LSP finds pyproject.toml / typings (default "temp" is outside it)
      shadow = { location = "workspace" },
    },
    config = function(_, opts)
      require("ipynb").setup(opts)

      -- Python not found: pick a venv with venv-selector, then retry with it (see venv-selector's on_venv_activate_callback)
      local kernel = require("ipynb.kernel")
      local connect = kernel.connect
      local group = vim.api.nvim_create_augroup("ipynb-venv-select", { clear = true })
      kernel.connect = function(state, copts)
        copts = copts or {}
        if copts.connection_file or copts.python_path or kernel.get_python_info(state.source_path) then
          return connect(state, copts)
        end
        vim.api.nvim_create_autocmd("User", {
          group = group,
          pattern = "VenvSelectActivated",
          once = true,
          callback = function()
            connect(state, vim.tbl_extend("force", copts, { python_path = require("venv-selector").python() }))
          end,
        })
        vim.cmd.VenvSelect()
        return false
      end
    end,
  }
}

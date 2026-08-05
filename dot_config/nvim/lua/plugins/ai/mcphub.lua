---@module "lazy"
---@type LazySpec
return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = "VeryLazy",
    -- cmd = { "MCPHub", "MCPHubToggle", "MCPHubOpen", "MCPHubClose" },
    opts = {
      cmd = vim.fn.exepath("mcp-hub") or "mcp-hub",
      config = vim.fn.expand("~/.config/mcp/mcp.json"),
      workspace = {
        enabled = true,
        look_for = { ".mcp.json" },
        reload_on_dir_changed = true,
      },
    },
  }
}

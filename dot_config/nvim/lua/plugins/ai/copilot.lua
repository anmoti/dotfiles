---@module "lazy"
---@type LazySpec
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "BufReadPost",
    ---@module "copilot"
    ---@type CopilotConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      ---@diagnostic disable-next-line: missing-fields
      panel = {
        enabled = false,
      },
      ---@diagnostic disable-next-line: missing-fields
      suggestion = {
        enabled = false,
      },
      server = {
        type = "binary",
        custom_server_filepath = "copilot-language-server",
      },
    },
  },
}

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
        enabled = true,
        auto_trigger = false,
      },
      server = {
        type = "binary",
        custom_server_filepath = "copilot-language-server",
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "fang2hou/blink-copilot",
    },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      sources = {
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            async = true,
          },
        },
      },
    },
  },
}

local guard = require("utils.guard")

local has_rust_fuzzy = guard.check({
  bin = {
    { "git", nix = "git" }, -- fuzzy.prebuilt_binaries (version)
    { "curl", nix = "curl" }, -- fuzzy.prebuilt_binaries (download)
    jit.os == "Windows" and "certutil" or { "sha256sum", nix = "coreutils" }, -- fuzzy.prebuilt_binaries (checksum)
  },
})

---@module "lazy"
---@type LazySpec
return {
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = {
      "fang2hou/blink-copilot",
      "L3MON4D3/LuaSnip",
    },
    event = { "InsertEnter", "CmdlineEnter" },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      fuzzy = {
        implementation = has_rust_fuzzy and "prefer_rust_with_warning" or "lua",
      },
      snippets = { preset = "luasnip" },
      keymap = {
        preset = "super-tab",
      },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "copilot", "buffer" },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "rounded",
          },
        },
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    lazy = true,
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}

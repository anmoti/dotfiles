local common = require("utils.common")

---@module "lspconfig"

---@class LspConfigOpts
---@field servers LspConfigServers

---@class LspConfigServers
---@field [string] LspConfigServer
---@field lua_ls? LspConfigServer.lua_ls
---@field jsonls? LspConfigServer.jsonls
---@field yamlls? LspConfigServer.yamlls
---@field tsc? LspConfigServer.tsc
---@field astro? LspConfigServer.astro
---@field svelte? LspConfigServer.svelte
---@field tailwindcss? LspConfigServer.tailwindcss
---@field buf_ls? LspConfigServer.buf_ls


---@class LspConfigServer: vim.lsp.Config
---@field settings? lsp.LSPObject
---@field setup? fun(server: LspConfigServer)
local default_server = {
  enabled = true,
  inlay_hints = true,
  settings = {},
  setup = function() end,
}

---@class LspConfigServer.lua_ls: LspConfigServer
---@field settings? lspconfig.settings.lua_ls
---@field setup? fun(server: LspConfigServer.lua_ls)

---@class LspConfigServer.jsonls: LspConfigServer
---@field settings? lspconfig.settings.jsonls
---@field setup? fun(server: LspConfigServer.jsonls)

---@class LspConfigServer.yamlls: LspConfigServer
---@field settings? lspconfig.settings.yamlls
---@field setup? fun(server: LspConfigServer.yamlls)

---@class LspConfigServer.tsc: LspConfigServer
---@field setup? fun(server: LspConfigServer.tsc)

---@class LspConfigServer.astro: LspConfigServer
---@field settings? lspconfig.settings.astro
---@field setup? fun(server: LspConfigServer.astro)

---@class LspConfigServer.svelte: LspConfigServer
---@field settings? lspconfig.settings.svelte
---@field setup? fun(server: LspConfigServer.svelte)

---@class LspConfigServer.tailwindcss: LspConfigServer
---@field settings? lspconfig.settings.tailwindcss
---@field setup? fun(server: LspConfigServer.tailwindcss)

---@class LspConfigServer.buf_ls: LspConfigServer
---@field setup? fun(server: LspConfigServer.buf_ls)


---@param lsp_name string
---@param server LspConfigServer
---@return LspConfigServer
local function apply_server_config(lsp_name, server)
  local tmp = common.removeKeys(server, { "enabled", "setup" })
  vim.lsp.config(lsp_name, server)

  local registered_config = vim.lsp.config[lsp_name]
  local result = vim.tbl_extend("keep", registered_config, tmp)

  return result
end

---@module "lazy"
---@type LazySpec
return {
  {
    --https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      "mrjones2014/codesettings.nvim",
    },
    ---@type LspConfigOpts
    opts = {
      servers = {
        dummy = {
          enabled = false,
        },
      },
    },

    ---@param opts LspConfigOpts
    config = function(_, opts)
      local blink_cmp = require("blink.cmp")
      local codesettings = require("codesettings")

      -- Inlay hint のグローバル有効化
      vim.lsp.inlay_hint.enable()

      ---@param server LspConfigServer
      for lsp_name, server in pairs(opts.servers) do
        -- Merge default settings
        server = vim.tbl_deep_extend("force", default_server, server)

        if not server.enabled then
          goto continue
        end

        -- Merge capabilities
        server.capabilities = blink_cmp.get_lsp_capabilities(server.capabilities)

        -- Merge local settings
        codesettings.with_local_settings(lsp_name, server)

        -- Merge lspconfig's config
        server = apply_server_config(lsp_name, server)

        if server.enabled then
          vim.api.nvim_create_autocmd("FileType", {
            pattern = server.filetypes,
            once = true,
            callback = function()
              if server.setup then
                server.setup(server)
                server = apply_server_config(lsp_name, server)
              end

              if server.enabled then
                vim.lsp.enable(lsp_name, true)
              end
            end,
          })
        end

        ::continue::
      end
    end,
  },
}

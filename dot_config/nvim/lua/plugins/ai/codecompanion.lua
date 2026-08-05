local doppler = require("utils.doppler")

---@module "lazy"
---@type LazySpec
return {
  {
    -- https://codecompanion.olimorris.dev/
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      'mrjones2014/codecompanion-ui.nvim',
      "ravitemer/mcphub.nvim",
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
    opts = {
      display = {
        chat = {
          window = {
            layout = "vertical",
            position = "right",
            width = 0.35,
          },
        },
      },
      opts = {
        language = "Japanese",
        log_level = "DEBUG",
      },
      env = {
        PATH = require("utils.path").resolved,
      },
      strategies = {
        chat = {
          adapter = "openrouter"
        },
        inline = {
          adapter = "openrouter"
        },
        cmd = {
          adapter = "openrouter"
        }
      },
      adapters = {
        http = {
          openrouter = function()
            return require("codecompanion.adapters").extend("openrouter", {
              env = {
                api_key = doppler.get_secret("CODECOMPANION_OPENROUTER_API_KEY"),
              },
              tools = {
                ["web_search"] = {
                  enabled = false,
                },
              },
            })
          end,
          gemini = function()
            local Curl = require("plenary.curl")
            local adapter_utils = require("codecompanion.adapters.utils")
            local config = require("codecompanion.config")
            local log = require("codecompanion.utils.log")

            local default_models = { "gemini-3.5-flash" }

            local _cache_expires
            local _cache_file = vim.fn.tempname()
            local _cached_models

            local function models(opts)
              if opts and opts.last then
                return _cached_models[1]
              end

              return _cached_models
            end

            local function get_gemini_models(self, opts)
              if _cached_models and _cache_expires and _cache_expires > os.time() then
                return models(opts)
              end

              _cached_models = {}

              local adapter = require("codecompanion.adapters").resolve(self)
              if not adapter then
                log:error("Could not resolve Gemini adapter in the `get_models` function")
                return default_models
              end

              adapter_utils.get_env_vars(adapter, { timeout = config.adapters.opts.cmd_timeout })
              local api_key = adapter.env_replaced.api_key

              if not api_key or api_key == "" or api_key:match("^cmd:") then
                log:error("Gemini API key is not valid or not resolved yet.")
                return default_models
              end

              local url_vars = "${url}${models_url}?pageSize=1000&key=${api_key}"
              local url = adapter_utils.set_env_vars(adapter, url_vars)
              local ok, response, json

              ok, response = pcall(function()
                return Curl.get(url, {
                  sync = true,
                  insecure = config.adapters.http.opts.allow_insecure,
                  proxy = config.adapters.http.opts.proxy,
                })
              end)

              if not ok or not response or response.status ~= 200 then
                log:error("Could not get Gemini models from API.\nError: %s", vim.inspect(response))
                return default_models
              end

              ok, json = pcall(vim.json.decode, response.body)
              if not ok or not json.models then
                log:error("Could not parse the response from Gemini API")
                return default_models
              end

              for _, model in ipairs(json.models) do
                local supported_methods = model.supportedGenerationMethods or {}
                for _, method in ipairs(supported_methods) do
                  if method == "generateContent" then
                    local model_name = model.name:gsub("^models/", "")
                    table.insert(_cached_models, model_name)
                    break
                  end
                end
              end

              _cache_expires = adapter_utils.refresh_cache(_cache_file,
                config.adapters.http.opts.cache_models_for or 3600)

              return models(opts)
            end

            local adapter = require("codecompanion.adapters").extend("gemini", {
              url = "${url}${models_url}/${model}${stream}",
              env = {
                url = "https://generativelanguage.googleapis.com",
                models_url = "/v1beta/models",
                api_key = doppler.get_secret("CODECOMPANION_GEMINI_API_KEY"),
              },
              headers = {
                ["x-goog-api-key"] = "${api_key}",
              },
              schema = {
                model = {
                  default = default_models[1],
                  choices = function(self)
                    return get_gemini_models(self)
                  end,
                },
              },
            })

            adapter.handlers.setup = function(self)
              self.opts.vision = true
              return true
            end

            local function strip_schema_key(tbl)
              if type(tbl) ~= "table" then return end
              tbl["$schema"] = nil -- $schema フィールドを削除
              for _, v in pairs(tbl) do
                if type(v) == "table" then
                  strip_schema_key(v)
                end
              end
            end

            local original_form_tools = adapter.handlers.form_tools
            adapter.handlers.form_tools = function(self, tools)
              local formatted_tools = original_form_tools(self, tools)
              if formatted_tools and formatted_tools.tools then
                strip_schema_key(formatted_tools.tools)
              end
              return formatted_tools
            end

            return adapter
          end,
          cerebras = function()
            local adapter = require("codecompanion.adapters").extend("openai_compatible", {
              formatted_name = "Cerebras",
              env = {
                url = "https://api.cerebras.ai",
                api_key = doppler.get_secret("CODECOMPANION_CEREBRAS_API_KEY"),
              },
              schema = {
                model = { default = "zai-glm-4.7" },
                stream = { default = true },
              },
            })

            local original_form_tools = adapter.handlers.form_tools
            adapter.handlers.form_tools = function(self, tools)
              local formatted_tools = original_form_tools(self, tools)
              vim.print(formatted_tools)

              return formatted_tools
            end

            return adapter
          end,
        },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
        ui = {
          enabled = true,
          opts = {
            input = {
              winbar = {
                {
                  component = 'mode',
                  hl = "GitSignsChangeInline",
                },
                { component = 'adapter' },
                { component = 'model' },
                {
                  component = 'spinner',
                  frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                },
                '%=',
                -- shows some status messages from the plugin briefly
                -- I recommend keeping this enabled
                { component = 'messages' },
              },
            },
            chat = {
              winbar = {
                {
                  component = 'chat_title',
                  hl = "GitSignsChangeInline",
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "codecompanion", "codecompanion_input" },
  },
}

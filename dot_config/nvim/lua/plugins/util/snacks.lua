return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
      toggle = {
        enabled = true,
        which_key = true,
      },
      picker = {
        enabled = true,
      },
      notifier = {
        enabled = true,
      },
      input = {
        enabled = true,
      },
      indent = {
        enabled = true,
      },
      terminal = {
        enabled = true,
      },
    },
    keys = {

      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fc",
        function()
          local history_file = vim.fn.stdpath("state") .. "/conf_history"

          local function update_conf_history(path)
            local dir = vim.fn.fnamemodify(history_file, ":h")
            if vim.fn.isdirectory(dir) == 0 then
              vim.fn.mkdir(dir, "p")
            end

            local lines = vim.fn.filereadable(history_file) == 1 and vim.fn.readfile(history_file) or {}
            local new_lines = { path }
            for _, line in ipairs(lines) do
              if line ~= path and #new_lines < 100 then
                table.insert(new_lines, line)
              end
            end
            vim.fn.writefile(new_lines, history_file)
          end

          local script_path = vim.fn.expand("~/.config/nvim/scripts/conf_list.sh")

          Snacks.picker.pick({
            title = "Find Config file",

            finder = function()
              local items = {}
              local seen = {}

              if vim.fn.filereadable(history_file) == 1 then
                for _, line in ipairs(vim.fn.readfile(history_file)) do
                  if line ~= "" and not seen[line] then
                    table.insert(items, {
                      text = line,
                      file = line,
                      dir = vim.fn.isdirectory(line) == 1,
                    })
                    seen[line] = true
                  end
                end
              end

              local script_output = vim.fn.systemlist(script_path)
              for _, line in ipairs(script_output) do
                if line ~= "" and not seen[line] then
                  table.insert(items, {
                    text = line,
                    file = line,
                    dir = vim.fn.isdirectory(line) == 1,
                  })
                  seen[line] = true
                end
              end

              return items
            end,

            sort = {
              fields = { "score:desc", "index" },
            },

            format = "file",
            preview = "file",

            confirm = function(picker, item)
              if not item then return end

              update_conf_history(item.file)

              local source_res = require("chezmoi.commands").source_path({
                targets = { item.file },
                on_stderr = function() end,
              })

              local resolved = source_res[1] or item.file

              picker:close()
              if item.dir then
                vim.fn.chdir(resolved)
                picker:close()
                Snacks.notify.info("Changed directory to: " .. resolved)
              else
                vim.cmd("edit " .. vim.fn.fnameescape(resolved))
              end
            end
          })
        end,
        desc = "Find Config file"
      },
      {
        "<C-\\>",
        function()
          Snacks.terminal.toggle(nil, {
            env = {
              PATH = vim.env.HOST_PATH or vim.env.PATH,
            },
          })
        end,
        desc = "Toggle terminal"
      },
    },
  },
}

local number_toggle_group = vim.api.nvim_create_augroup("NumberToggle", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
  group = number_toggle_group,
  callback = function()
    if vim.opt.number:get() then
      vim.opt.relativenumber = false
    end
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = number_toggle_group,
  callback = function()
    if vim.opt.number:get() then
      vim.opt.relativenumber = true
    end
  end,
})


local fix_mode_jump_group = vim.api.nvim_create_augroup('FixModeJump', { clear = true })

local last_mode = vim.fn.mode()
local last_winline = vim.fn.winline()
local is_updating = false

local target_modes = { i = true, n = true, v = true, V = true, [''] = true }

local function update_state()
  if is_updating then return end
  is_updating = true

  last_mode = vim.fn.mode()
  last_winline = vim.fn.winline()

  vim.defer_fn(function()
    is_updating = false
  end, 10)
end

vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'ModeChanged' }, {
  group = fix_mode_jump_group,
  callback = function()
    if is_updating then return end

    local curr_mode = vim.fn.mode()
    local curr_winline = vim.fn.winline()

    local is_target_transition = target_modes[last_mode] and target_modes[curr_mode] and (last_mode ~= curr_mode)
    local winline_diff = last_winline - curr_winline

    if is_target_transition and winline_diff ~= 0 then
      vim.print(string.format("Mode changed from '%s' %d to '%s' %d", last_mode, last_winline, curr_mode, curr_winline))
      local view = vim.fn.winsaveview()
      view.topline = view.topline + winline_diff
      vim.fn.winrestview(view)
    end

    update_state()
  end
})

vim.api.nvim_set_hl(0, "Zenkaku", { bg = "#f9e2af", fg = "#1e1e2e" })

local zenkaku_group = vim.api.nvim_create_augroup("Zenkaku", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "TermOpen" }, {
  group = zenkaku_group,
  callback = function()
    -- matchadd is window-local, clear before re-adding
    for _, match in ipairs(vim.fn.getmatches()) do
      if match.group == "Zenkaku" then
        vim.fn.matchdelete(match.id)
      end
    end
    if vim.bo.buftype == "terminal" then return end
    vim.fn.matchadd("Zenkaku", "[\\u3000\\uff01-\\uff5e]") -- 　！-～
  end,
})

local function is_claude_code_buf(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype ~= "terminal" then return false end
  local ok, terminal = pcall(require, "claudecode.terminal")
  if not ok then return false end
  return terminal.get_active_terminal_bufnr() == buf
end

-- Stores Claude Code window width when a normal buffer window is closing alongside it.
-- nil means inactive; a number means WinClosed should open the dashboard and restore that width.
local claude_win_width_on_close = nil

-- https://zenn.dev/vim_jp/articles/ff6cd224fab0c7
vim.api.nvim_create_autocmd('QuitPre', {
  callback = function()
    claude_win_width_on_close = nil

    if vim.bo.buftype == "terminal" then return end

    local current_win = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if win ~= current_win then
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == '' then return end
        if is_claude_code_buf(buf) then
          claude_win_width_on_close = vim.api.nvim_win_get_width(win)
          return
        end
      end
    end

    vim.cmd.only({ bang = true })
  end,
  desc = 'Close all special buffers and quit Neovim',
})

vim.api.nvim_create_autocmd('WinClosed', {
  callback = function()
    if not claude_win_width_on_close then return end
    local saved_width = claude_win_width_on_close
    claude_win_width_on_close = nil

    vim.schedule(function()
      local claude_win = nil
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_is_valid(win) and is_claude_code_buf(vim.api.nvim_win_get_buf(win)) then
          claude_win = win
          break
        end
      end
      if not claude_win then return end

      vim.api.nvim_set_current_win(claude_win)
      vim.cmd("leftabove vsplit")
      vim.api.nvim_win_set_width(claude_win, saved_width)
      require("snacks").dashboard.open({ win = vim.api.nvim_get_current_win() })
    end)
  end,
  desc = 'Open Snacks dashboard when only Claude Code terminal remains',
})

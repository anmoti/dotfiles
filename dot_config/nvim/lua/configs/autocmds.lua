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

-- https://zenn.dev/vim_jp/articles/ff6cd224fab0c7
vim.api.nvim_create_autocmd('QuitPre', {
  callback = function()
    -- 現在のウィンドウ番号を取得
    local current_win = vim.api.nvim_get_current_win()
    -- すべてのウィンドウをループして調べる
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      -- カレント以外を調査
      if win ~= current_win then
        local buf = vim.api.nvim_win_get_buf(win)
        -- buftypeが空文字（通常のバッファ）があればループ終了
        if vim.bo[buf].buftype == '' then
          return
        end
      end
    end
    -- ここまで来たらカレント以外がすべて特殊ウィンドウということなので
    -- カレント以外をすべて閉じる
    vim.cmd.only({ bang = true })
    -- この後、ウィンドウ1つの状態でquitが実行されるので、Vimが終了する
  end,
  desc = 'Close all special buffers and quit Neovim',
})

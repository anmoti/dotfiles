-- https://blog.printemps.tokyo/blog/neovim-sudo-write-without-plugin
vim.api.nvim_create_user_command('RootWrite', function()
  local filepath = vim.fn.expand('%:p')
  local cmd = string.format('/usr/bin/pkexec tee %s > /dev/null', vim.fn.shellescape(filepath))

  -- バッファの内容を sudo tee に渡す
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, '\n')
  local result = vim.fn.system(cmd, content .. '\n')

  -- 結果を確認
  if vim.v.shell_error == 0 then
    vim.bo.modified = false
    vim.cmd('checktime')
    vim.notify('File saved with sudo', vim.log.levels.INFO)
  else
    vim.notify('Failed to save: ' .. result, vim.log.levels.ERROR)
  end
end, { desc = 'Write file with pkexec' })

vim.keymap.set('c', 'w!!', ':RootWrite<CR>', {
  silent = false,
  desc = 'Write current file as root'
})

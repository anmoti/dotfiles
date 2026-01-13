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

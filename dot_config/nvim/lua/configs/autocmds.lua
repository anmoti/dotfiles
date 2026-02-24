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

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function ()
    local arg = vim.fn.argv(0)
    if arg == nil or arg == "" then return end

    local path = vim.fn.fnamemodify(arg, ":p")
    local target_dir = vim.fn.isdirectory(path) == 1 and path or vim.fn.fnamemodify(path, ":h")

    vim.fn.chdir(target_dir)
  end
})

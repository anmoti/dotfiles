vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, {
      buffer = args.buf,
      desc = "Hover",
    })
    vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, {
      buffer = args.buf,
      desc = "LSP Code Action",
    })
  end,
})

vim.keymap.set("n", "<leader>lh", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, {
  desc = "Hover",
})

vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, {
  desc = "LSP Code Action",
})

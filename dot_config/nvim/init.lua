vim.cmd(":colorscheme vim")

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
	pattern = "*config/waybar/config",
	command = "setfiletype jsonc",
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
	pattern = "*config/sway/config*",
	command = "setfiletype swayconfig",
})

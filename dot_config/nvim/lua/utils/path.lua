local M = {}

local host_path = vim.env.HOST_PATH
local nvim_path = vim.env.PATH

M.resolved = nvim_path .. (host_path and (":" .. host_path) or "")

return M

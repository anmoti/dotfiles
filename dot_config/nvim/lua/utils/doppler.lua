local M = {}

local secret_cache = {}

---@param name string
function M.get_secret(name)
  if secret_cache[name] then
    return secret_cache[name]
  end

  local cmd = string.format(
    "doppler secrets get %s --project %s --config %s --plain 2>/dev/null",
    name,
    "home-lab",
    "prd"
  )

  local handle = io.popen(cmd)
  if not handle then
    vim.notify("Failed to execute doppler command", vim.log.levels.ERROR)
    return nil
  end

  local value = handle:read("*a"):gsub("\n$", "")
  handle:close()

  if value == "" then
    return nil
  end

  secret_cache[name] = value

  return value
end

return M

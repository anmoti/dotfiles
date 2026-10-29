local M = {
  ---@type table<string, table<string, boolean>>
  loaded = {},
}

---@class GuardBinEntry
---@field [1] string
---@field nix? string
---@field proto? string

---@class GuardDeps
---@field bin? (string|GuardBinEntry)[]
---@field lang? string[]
---@field ai? string[]
---@field util? string[]
---@field ui? string[]

---@param deps GuardDeps
---@return boolean
function M.check(deps)
  local source = debug.getinfo(2, "S").source:sub(2)
  local name = vim.fn.fnamemodify(source, ":t:r"):gsub("^%d+%-", "")
  local category = vim.fn.fnamemodify(source, ":h:t")

  M.loaded[category] = M.loaded[category] or {}
  deps = deps or {}

  local ok = true
  for k, v in pairs(deps) do
    if k ~= "bin" and type(v) == "table" then
      local cat_loaded = M.loaded[k] or {}
      for _, req in ipairs(v) do
        if not cat_loaded[req] then
          ok = false
          break
        end
      end
    end
    if not ok then
      break
    end
  end

  if ok and deps.bin then
    for _, entry in ipairs(deps.bin) do
      local cmd = type(entry) == "table" and entry[1] or entry
      if vim.fn.executable(cmd) ~= 1 then
        ok = false
        break
      end
    end
  end

  if M.loaded[category][name] == nil then
    M.loaded[category][name] = ok
  end
  return ok
end

return M

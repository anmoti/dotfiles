local M = {}

function M.removeKeys(tbl, keys)
    local removed = {}
    for _, k in ipairs(keys) do
        removed[k] = tbl[k]
        tbl[k] = nil
    end
    return removed
end

return M

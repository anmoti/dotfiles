local c = require("catppuccin-mocha")

local opacity = {
  opaque   = 1.00,
  active   = 0.97,
  subtle   = 0.95, -- app-styled inactive (Alacritty, browser, etc.)
  inactive = 0.93,
  media    = 0.90, -- background media windows active
  dim      = 0.85, -- background media windows inactive
  border   = 0.93,
  overlay  = 0.67,
}

---@param active number
---@param inactive number?
local function opacity_str(active, inactive)
  if inactive then
    return string.format("%.2f %.2f", active, inactive)
  end
  return string.format("%.2f", active)
end

local accent = c.mauve

return {
  opacity     = opacity,
  opacity_str = opacity_str,
  accent      = accent,

  border      = {
    active   = { colors = { accent(opacity.border), c.blue(opacity.border) }, angle = 315 },
    inactive = c.surface1(opacity.overlay),
  },

  shadow      = {
    color = c.crust(opacity.border),
  },
}

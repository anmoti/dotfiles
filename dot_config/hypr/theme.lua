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
---@param fullscreen number?
local function opacity_str(active, inactive, fullscreen)
  if fullscreen then
    return string.format("%.2f override %.2f override %.2f override", active, inactive, fullscreen)
  elseif inactive then
    return string.format("%.2f override %.2f override", active, inactive)
  end
  return string.format("%.2f override", active)
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

-- Catppuccin Mocha palette for Hyprland Lua config
--
-- Usage:
--   local c = require("catppuccin-mocha")
--   c.base(1)     --> "rgb(1e1e2e)"
--   c.base(0.85)  --> "rgba(1e1e2ed9)"

---@param r integer
---@param g integer
---@param b integer
---@return fun(opacity: number): string
local function color(r, g, b)
  ---@param opacity number 0.0 – 1.0
  return function(opacity)
    if opacity >= 1.0 then
      return string.format("rgb(%02x%02x%02x)", r, g, b)
    end
    local a = math.floor(opacity * 255 + 0.5)
    return string.format("rgba(%02x%02x%02x%02x)", r, g, b, a)
  end
end

return {
  rosewater = color(245, 224, 220),
  flamingo  = color(242, 205, 205),
  pink      = color(245, 194, 231),
  mauve     = color(203, 166, 247),
  red       = color(243, 139, 168),
  maroon    = color(235, 160, 172),
  peach     = color(250, 179, 135),
  yellow    = color(249, 226, 175),
  green     = color(166, 227, 161),
  teal      = color(148, 226, 213),
  sky       = color(137, 220, 235),
  sapphire  = color(116, 199, 236),
  blue      = color(137, 180, 250),
  lavender  = color(180, 190, 254),
  text      = color(205, 214, 244),
  subtext1  = color(186, 194, 222),
  subtext0  = color(166, 173, 200),
  overlay2  = color(147, 153, 178),
  overlay1  = color(127, 132, 156),
  overlay0  = color(108, 112, 134),
  surface2  = color( 88,  91, 112),
  surface1  = color( 69,  71,  90),
  surface0  = color( 49,  50,  68),
  base      = color( 30,  30,  46),
  mantle    = color( 24,  24,  37),
  crust     = color( 17,  17,  27),
}

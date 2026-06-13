---@class Monitor
---@field scale number
---@field w number
---@field h number

local transform = {
  horizontal = 0,
  vertical = 1,
  horizontal_reverse = 2,
  verical_reverse = 3,
  flipped_horizontal = 4,
  flipped_vertical = 5,
  flipped_horizontal_reverse = 6,
  flipped_vertical_reverse = 7,
}

hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto",
})

---@type Monitor
local legi = {
  scale = 1.60,
  w = 2560,
  h = 1440,
  x = 0,
  y = 0,
}

hl.monitor({
  output = "desc:California Institute of Technology 0x1509",
  mode = string.format("%dx%d@165.00", legi.w, legi.h),
  position = string.format("%dx%d", legi.x, legi.y),
  scale = string.format("%.02f", legi.scale),
  vrr = 1,
})

hl.bind("switch:on:Lid Switch", hl.dsp.dpms({ action = "off", monitor = "eDP-1" }))
hl.bind("switch:off:Lid Switch", hl.dsp.dpms({ action = "on", monitor = "eDP-1" }))

---@type Monitor
local xiao = {
  scale = 1.00,
  w = 1920,
  h = 1080,
  x = nil,
  y = nil,
}
xiao.x = legi.x + (((legi.w / legi.scale) - (xiao.w / xiao.scale)) / 2)
xiao.y = legi.y - (xiao.h / xiao.scale)

hl.monitor({
  output = "desc:Xiaomi Corporation P24FBA-RAGL 5438700015282",
  mode = string.format("%dx%d@100.00", xiao.w, xiao.h),
  position = string.format("%dx%d", xiao.x, xiao.y),
  scale = "1.00",
  vrr = 1,
  transform = transform.horizontal_reverse,
})

---@type Monitor
local mobi = {
  scale = 1.20,
  w = 1920,
  h = 1080,
  x = nil,
  y = nil,
}
mobi.x = legi.x - (mobi.w / mobi.scale)
mobi.y = legi.y

hl.monitor({
  output = "desc:Invalid Vendor Codename - RTK C-1 demoset-1",
  mode = string.format("%dx%d@60.00", mobi.w, mobi.h),
  position = string.format("%dx%d", mobi.x, mobi.y),
  scale = "1.20",
})

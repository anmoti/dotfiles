-- 常時起動アプリをWS11から動的に詰めてウィンドウをわりあてるルール
local MAX_WS = 10

---@class app : HL.WindowRuleSpec
---@field rules? table<number, HL.WindowRule>

---@type app[]
local apps = {
  {
    name = "jquake",
    match = {
      class = "net-jquake-app-Main",
      title = "JQuake",
    },
    monitor = 0
  },
  {
    name = "steam",
    match = { class = "steam" },
  },
  {
    name = "youtube-music",
    match = { class = "com.github.th_ch.youtube_music" },
    monitor = 0
  },
  {
    name = "legcord",
    match = { class = "legcord" },
  },
  {
    name = "teams-for-linux",
    match = { class = "teams-for-linux" },
  },
}

---@param app app
---@param ws number
---@return HL.WindowRuleSpec
local function build_rule_spec(app, ws)
  ---@type HL.WindowRuleSpec
  local rule_spec = { workspace = ws }
  for k, v in pairs(app) do
    if k == "name" then v = v .. "-persistent-" .. ws end
    if k ~= "rules" then rule_spec[k] = v end
  end
  return rule_spec
end

for _, app in ipairs(apps) do
  app.rules = {}
  app.rules[MAX_WS + 1] = hl.window_rule(build_rule_spec(app, MAX_WS + 1))
end

-- window.closeは閉じアニメーション中(まだget_workspace_windowsに残る)に発火するので、
-- 閉じかけウィンドウを記録して packing 時にスキップする
local closing = {}

local is_updating = false
local function update_window_rules()
  if is_updating then return end
  is_updating = true

  -- ウィンドウを詰める
  local next_ws = MAX_WS + 1
  local wss = hl.get_workspaces()
  table.sort(wss, function(a, b) return a.id < b.id end)
  for _, ws in ipairs(wss) do
    if ws.id < next_ws then goto continue end
    local wins = {}
    for _, w in ipairs(hl.get_workspace_windows(ws)) do
      if not closing[w.address] then wins[#wins + 1] = w end
    end
    if #wins == 0 then goto continue end
    if ws.id == next_ws then goto continue_ok end
    for _, win in ipairs(wins) do
      hl.dispatch(hl.dsp.window.move({ workspace = next_ws, follow = false, window = win }))
    end
    ::continue_ok::
    next_ws = next_ws + 1
    ::continue::
  end

  -- 次の空きスロットへルールを更新
  for _, app in ipairs(apps) do
    for _, rule in pairs(app.rules) do
      rule:set_enabled(false)
    end

    if app.rules[next_ws] then
      app.rules[next_ws]:set_enabled(true)
    else
      app.rules[next_ws] = hl.window_rule(build_rule_spec(app, next_ws))
    end
  end

  is_updating = false
end

update_window_rules()

hl.on("window.open", update_window_rules)
hl.on("window.close", function(w)
  closing[w.address] = true
  update_window_rules()
end)
hl.on("window.destroy", function(w)
  closing[w.address] = nil
  update_window_rules()
end)
hl.on("window.move_to_workspace", update_window_rules)

local apps = require("apps")

do
  hl.config({
    input = {
      kb_layout          = "jp",
      kb_variant         = "",
      kb_model           = "",
      kb_options         = "",
      kb_rules           = "",

      numlock_by_default = true,

      follow_mouse       = 1,

      sensitivity        = 0, -- -1.0 - 1.0, 0 means no modification.

      touchpad           = {
        natural_scroll = true,
      },
    },

    misc = {
      middle_click_paste = false,
    }
  })

  hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace"
  })

  hl.device({
    name        = "razer-razer-viper-ultimate",
    sensitivity = -0.5,
  })

  hl.device({
    name        = "elecom-blueled-mouse",
    sensitivity = -0.5,
  })

  local mainMod = "SUPER"
  local LMB = "mouse:272"
  local RMB = "mouse:273"

  ---@param key string
  function MOD_(key)
    return mainMod .. " + " .. key
  end

  ---@param key string
  function MODS(key)
    return MOD_("SHIFT + " .. key)
  end

  ---@param key string
  function MODC(key)
    return MOD_("CTRL + " .. key)
  end

  hl.bind(MOD_ "RETURN", hl.dsp.exec_cmd(apps.terminal))
  hl.bind(MOD_ "SPACE", hl.dsp.exec_cmd(apps.menu))
  hl.bind(MOD_ "E", hl.dsp.exec_cmd(apps.fileManager))
  hl.bind(MOD_ "O", hl.dsp.exec_cmd(apps.browser))

  hl.bind(MOD_ "L", hl.dsp.exec_cmd(apps.lock))

  hl.bind(MODS "C", hl.dsp.exec_cmd("hyprpicker --autocopy --format=hex"))
  hl.bind("Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot_satty.sh"))

  hl.bind(MOD_ "F", hl.dsp.window.float({ action = "toggle" }))
  hl.bind(MOD_ "P", hl.dsp.window.pseudo())
  hl.bind(MOD_ "J", hl.dsp.layout("togglesplit")) -- dwindle only
  hl.bind(MOD_ "Q", hl.dsp.window.close())

  local directions = { "left", "right", "up", "down" }
  for i, dir in ipairs(directions) do
    hl.bind(MOD_(dir), hl.dsp.focus({ direction = dir }))
    hl.bind(MODS(dir), hl.dsp.window.move({ direction = dir }))

    local is_horizontal = (i <= 2)
    local amt = (i % 2 == 0) and 10 or -10

    local x = is_horizontal and amt or 0
    local y = is_horizontal and 0 or amt

    hl.bind(MODC(dir), hl.dsp.window.resize({ x = x, y = y, relative = true }))
  end

  for i = 1, 10 do
    local key = tostring(i % 10) -- 10 maps to key 0
    hl.bind(MOD_(key), hl.dsp.focus({ workspace = i }))
    hl.bind(MODS(key), hl.dsp.window.move({ workspace = i }))
  end

  hl.bind(MOD_ "mouse_up", hl.dsp.focus({ workspace = "m+1" }))
  hl.bind(MOD_ "mouse_down", hl.dsp.focus({ workspace = "m-1" }))
  hl.bind(MODS "mouse_up", hl.dsp.window.move({ workspace = "m+1" }))
  hl.bind(MODS "mouse_down", hl.dsp.window.move({ workspace = "m-1" }))

  hl.bind(MOD_(LMB), hl.dsp.window.drag(), { mouse = true })
  hl.bind(MOD_(RMB), hl.dsp.window.resize(), { mouse = true })

  hl.bind(MOD_ "S", hl.dsp.workspace.toggle_special("magic"))
  hl.bind(MODS "S", hl.dsp.window.move({ workspace = "special:magic" }))

  hl.bind(MODS "R", function()
    hl.dispatch(hl.dsp.force_renderer_reload())
    hl.exec_cmd("killall -SIGUSR2 waybar")
  end)

  hl.bind(MOD_ "M", hl.dsp.exit())

  hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.0"),
    { locked = true, repeating = true })
  hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
  hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
  hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
  hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.local/bin/change-brightness set +5"),
    { locked = true, repeating = true })
  hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.local/bin/change-brightness set -5"),
    { locked = true, repeating = true })

  -- Requires playerctl
  hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
  hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
  hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
  hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
end

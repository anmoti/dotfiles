local t = require("theme")

hl.config({
  general = {
    gaps_in          = 5,
    gaps_out         = 10,

    border_size      = 2,

    col              = {
      active_border   = t.border.active,
      inactive_border = t.border.inactive,
    },

    -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false,

    -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
    allow_tearing    = false,

    layout           = "dwindle",
  },

  decoration = {
    rounding         = 5,
    rounding_power   = 2,

    active_opacity   = t.opacity.active,
    inactive_opacity = t.opacity.inactive,

    shadow           = {
      enabled      = true,
      range        = 4,
      render_power = 3,
      color        = t.shadow.color,
    },

    blur             = {
      enabled  = true,
      size     = 3,
      passes   = 1,
      vibrancy = 0.1696,
    },
  },
})

hl.layer_rule({
  name = "waybar",
  match = { namespace = "waybar" },
  blur = true,
})

local FSMode = {
  none                 = 0,
  maximize             = 1,
  fullscreen           = 2,
  maximized_fullscreen = 3,
}

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name = "fix-xwayland-drags",
  match = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },
  no_focus = true,
})

hl.window_rule({
  name = "global-behavior",
  match = { class = ".*" },
  opacity = t.opacity_str(t.opacity.active, t.opacity.inactive),
  suppress_event = "maximize",
  focus_on_activate = true,
})

hl.window_rule({
  name    = "disable-opacity-when-fullscreeen",
  match   = { fullscreen_state_client = FSMode.fullscreen },
  opacity = t.opacity_str(t.opacity.opaque),
})

hl.window_rule({
  name = "unity",
  match = { class = "Unity" },
  workspace = "5",
  focus_on_activate = false,
})

hl.window_rule({
  name    = "app-styled-opacity",
  match   = { class = "Alacritty|legcord|floorp" },
  opacity = t.opacity_str(t.opacity.opaque, t.opacity.subtle),
})

hl.window_rule({
  name = "float-floorp-popup",
  match = {
    class         = "floorp",
    initial_title = "negative:Ablaze Floorp",
  },
  float = true,
})

hl.window_rule({
  name = "vivaldi-bitwarden",
  match = {
    class = "vivaldi-.+",
    title = "Bitwarden - Vivaldi",
  },
  float = true,
})

hl.window_rule({
  name = "devtools",
  match = { title = "(Developer|開発) ?(Tools|ツール)" },
  float = true,
  size = "monitor_w*0.5 monitor_h*0.8",
})

hl.window_rule({
  name = "youtube-music",
  match = { class = "com.github.th_ch.youtube_music" },
  opacity = t.opacity_str(t.opacity.media, t.opacity.dim),
})

hl.window_rule({
  name = "jquake",
  match = {
    class = "net-jquake-app-Main",
    title = "JQuake", -- 設定ウィンドウに影響を与えないため指定
  },
  float = false,
  opacity = t.opacity_str(t.opacity.media, t.opacity.dim),
})

hl.window_rule({
  name  = "blueman-manager",
  match = { class = "blueman-manager" },
  float = true,
  size  = "700 400",
})

hl.window_rule({
  name = "pavucontrol",
  match = { class = "org.pulseaudio.pavucontrol" },
  float = true,
  size = "700, 400",
})

hl.window_rule({
  name  = "alacritty-mode-float",
  match = { class = "AlacrittyFloat" },
  float = true,
})

hl.window_rule({
  name  = "imhex",
  match = { class = "imhex" },
  float = false,
})

hl.window_rule({
  name   = "1password",
  match  = { class = "1password" },
  float  = true,
  center = true,
})

hl.window_rule({
  name  = "burp-suite-filter",
  match = { title = "HTTP history filter" },
  float = true,
  size  = "1100 320",
})

hl.window_rule({
  name = "filemanager",
  match = { class = "nemo|org.gnome.FileRoller" },
  float = true,
  size = "900 600",
})

hl.window_rule({
  name = "settings",
  match = { title = ".*([Ss]etting|設定).*" },
  float = true,
})

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.config({
  xwayland = {
    force_zero_scaling = true,
  },
})

local c = require("catppuccin-mocha")

hl.window_rule({
  name                = "disable-hyprbars",
  match               = { float = false },
  ["hyprbars:no_bar"] = true,
})

if hl.plugin.hyprbars ~= nil then
  hl.config({
    plugin = {
      hyprbars = {
        bar_height                 = 24,
        bar_color                  = c.surface0(0.745),
        bar_blur                   = true,
        bar_title_enabled          = true,
        bar_text_size              = 10,
        col                        = { text = c.text(1.0) },
        bar_text_font              = "JetBrainsMono",
        bar_text_align             = "center",
        bar_buttons_alignment      = "right",
        inactive_button_color      = c.subtext0(1.0),
        on_double_click            = "hyprctl dispatch 'hl.dsp.window.float({ action = \"toggle\" })'",
        bar_part_of_window         = true,
        bar_precedence_over_border = false,
      },
    },
  })

  hl.plugin.hyprbars.add_button({
    bg_color = c.red(1.0),
    fg_color = c.base(1.0),
    size     = 12,
    icon     = "",
    action   = "hyprctl dispatch 'hl.dsp.window.close()'",
  })

  hl.plugin.hyprbars.add_button({
    bg_color = c.yellow(1.0),
    fg_color = c.base(1.0),
    size     = 12,
    icon     = "",
    action   = [[hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })']],
  })
end

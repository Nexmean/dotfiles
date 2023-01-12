local wezterm = require "wezterm"

return {
  font = wezterm.font "JetbrainsMono Nerd Font",
  font_size = 16,
  color_scheme = "Catppuccin Mocha",
  default_cursor_style = "SteadyBar",
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  term = "wezterm",
  hide_tab_bar_if_only_one_tab = true,
  detect_password_input = true,
  initial_cols = 140,
  initial_rows = 40,
  use_resize_increments = true,
  use_fancy_tab_bar = false,
  tab_max_width = 20,
  max_fps = 120,
}

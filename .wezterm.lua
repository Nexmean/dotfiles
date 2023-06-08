local wezterm = require "wezterm"

local function is_vi_process(pane)
  return pane:get_foreground_process_name():find "n?vim" ~= nil
end

local function conditional_activate_pane(window, pane, pane_direction, vim_direction)
  if is_vi_process(pane) then
    window:perform_action(wezterm.action.SendKey { key = vim_direction, mods = "ALT" }, pane)
  else
    window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
  end
end

wezterm.on("ActivatePaneDirection-right", function(window, pane)
  conditional_activate_pane(window, pane, "Right", "l")
end)
wezterm.on("ActivatePaneDirection-left", function(window, pane)
  conditional_activate_pane(window, pane, "Left", "h")
end)
wezterm.on("ActivatePaneDirection-up", function(window, pane)
  conditional_activate_pane(window, pane, "Up", "k")
end)
wezterm.on("ActivatePaneDirection-down", function(window, pane)
  conditional_activate_pane(window, pane, "Down", "j")
end)

local colors = {
  rosewater = "#F4DBD6",
  flamingo = "#F0C6C6",
  pink = "#F5BDE6",
  mauve = "#C6A0F6",
  red = "#ED8796",
  maroon = "#EE99A0",
  peach = "#F5A97F",
  yellow = "#EED49F",
  green = "#A6DA95",
  teal = "#8BD5CA",
  sky = "#91D7E3",
  sapphire = "#7DC4E4",
  blue = "#8AADF4",
  lavender = "#B7BDF8",

  text = "#CAD3F5",
  subtext1 = "#B8C0E0",
  subtext0 = "#A5ADCB",
  overlay2 = "#939AB7",
  overlay1 = "#8087A2",
  overlay0 = "#6E738D",
  surface2 = "#5B6078",
  surface1 = "#494D64",
  surface0 = "#363A4F",

  base = "#24273A",
  mantle = "#1E2030",
  crust = "#181926",
}

local function get_process(tab)
  local process_icons = {
    ["docker"] = {
      { Foreground = { Color = colors.blue } },
      { Text = wezterm.nerdfonts.linux_docker },
    },
    ["docker-compose"] = {
      { Foreground = { Color = colors.blue } },
      { Text = wezterm.nerdfonts.linux_docker },
    },
    ["nvim"] = {
      { Foreground = { Color = colors.green } },
      { Text = wezterm.nerdfonts.custom_vim },
    },
    ["vim"] = {
      { Foreground = { Color = colors.green } },
      { Text = wezterm.nerdfonts.dev_vim },
    },
    ["node"] = {
      { Foreground = { Color = colors.green } },
      { Text = wezterm.nerdfonts.mdi_hexagon },
    },
    ["zsh"] = {
      { Foreground = { Color = colors.peach } },
      { Text = wezterm.nerdfonts.dev_terminal },
    },
    ["bash"] = {
      { Foreground = { Color = colors.subtext0 } },
      { Text = wezterm.nerdfonts.cod_terminal_bash },
    },
    ["htop"] = {
      { Foreground = { Color = colors.yellow } },
      { Text = wezterm.nerdfonts.mdi_chart_donut_variant },
    },
    ["cargo"] = {
      { Foreground = { Color = colors.peach } },
      { Text = wezterm.nerdfonts.dev_rust },
    },
    ["go"] = {
      { Foreground = { Color = colors.sapphire } },
      { Text = wezterm.nerdfonts.mdi_language_go },
    },
    ["lazydocker"] = {
      { Foreground = { Color = colors.blue } },
      { Text = wezterm.nerdfonts.linux_docker },
    },
    ["git"] = {
      { Foreground = { Color = colors.peach } },
      { Text = wezterm.nerdfonts.dev_git },
    },
    ["lazygit"] = {
      { Foreground = { Color = colors.peach } },
      { Text = wezterm.nerdfonts.dev_git },
    },
    ["lua"] = {
      { Foreground = { Color = colors.blue } },
      { Text = wezterm.nerdfonts.seti_lua },
    },
    ["wget"] = {
      { Foreground = { Color = colors.yellow } },
      { Text = wezterm.nerdfonts.mdi_arrow_down_box },
    },
    ["curl"] = {
      { Foreground = { Color = colors.yellow } },
      { Text = wezterm.nerdfonts.mdi_flattr },
    },
    ["gh"] = {
      { Foreground = { Color = colors.mauve } },
      { Text = wezterm.nerdfonts.dev_github_badge },
    },
  }

  local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")

  return wezterm.format(
    process_icons[process_name]
      or { { Foreground = { Color = colors.sky } }, { Text = string.format("[%s]", process_name) } }
  )
end

local function get_current_working_dir(tab)
  local current_dir = tab.active_pane.current_working_dir
  local HOME_DIR = string.format("file://%s", os.getenv "HOME")

  return current_dir == HOME_DIR and "~"
    or string.format("%s", string.gsub(current_dir, "(.*[/\\])(.*)", "%2"))
end

wezterm.on("format-tab-title", function(tab)
  return wezterm.format {
    { Attribute = { Intensity = "Half" } },
    { Text = string.format(" %s: ", tab.tab_index + 1) },
    "ResetAttributes",
    { Text = get_process(tab) },
    { Text = " " },
    { Text = get_current_working_dir(tab) },
    { Foreground = { Color = colors.base } },
    { Text = "▕" },
  }
end)

wezterm.on("update-right-status", function(window)
  window:set_right_status(wezterm.format {
    { Attribute = { Intensity = "Bold" } },
    { Text = wezterm.strftime " %A, %d %B %Y %H:%M " },
  })
end)

return {
  font = wezterm.font "JetbrainsMono Nerd Font",
  font_size = 17,
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
  max_fps = 144,
  window_decorations = "RESIZE",
}

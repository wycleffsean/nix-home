local wezterm = require 'wezterm';

return {
  enable_wayland = true,
  warn_about_missing_glyphs = false,
  default_cursor_style = "BlinkingBlock",
  enable_scroll_bar = true,
  font = wezterm.font('FiraMono Nerd Font'),
  -- font = wezterm.font('Inconsolata-g for Powerline'),
  -- font = wezterm.font('Inconsolata-g for powerline'),
  -- font = wezterm.font("Fira Code"),
  -- font = wezterm.font_with_fallback({"Fira Code"}),
  -- font = wezterm.font("JetBrains Mono", {weight="Bold", italic=true})
  use_fancy_tab_bar = true,
  -- cursor_blink_rate = 800, -- bad for battery :/
  colors = {
      -- The default text color
      foreground = "#eff0ea",
      -- The default background color
      background = "#272935",

      -- Overrides the cell background color when the current cell is occupied by the
      -- cursor and the cursor style is set to Block
      cursor_fg = "#272935",
      -- Overrides the text color when the current cell is occupied by the cursor
      cursor_bg = "#eff0ea",
      -- Specifies the border color of the cursor when the cursor style is set to Block,
      -- of the color of the vertical or horizontal bar when the cursor style is set to
      -- Bar or Underline.
      cursor_border = "#52ad70",

      -- the foreground color of selected text
      selection_fg = "#000000",
      -- the background color of selected text
      selection_bg = "#92bbd0",

      -- The color of the scrollbar "thumb"; the portion that represents the current viewport
      scrollbar_thumb = "#666666",

      -- The color of the split lines between panes
      split = "#444444",

      -- ansi = {"black", "maroon", "green", "olive", "navy", "purple", "teal", "silver"},
      ansi = {"black", "#ff5b56", "#5af78d", "#f3f99c", "#57c7fe", "#ff69c0", "#9aecfe", "#f1f1f0"},
      brights = {"#686767", "#ff5b56", "#5af78d", "#f3f99c", "#57c7fe", "#ff69c0", "#9aecfe", "#f1f1f0"},

      -- Arbitrary colors of the palette in the range from 16 to 255
      -- indexed = {[136] = "#af8700"},
  },
  keys = {
    { mods="SUPER", key="k", action=wezterm.action{ClearScrollback="ScrollbackAndViewport"}},
    { mods="SUPER", key="[", action=wezterm.action{ActivatePaneDirection="Left"}},
    { mods="SUPER", key="]", action=wezterm.action{ActivatePaneDirection="Right"}},
    { mods="SHIFT|ALT", key="[", action=wezterm.action{MoveTabRelative=-1}}, -- these next 4 don't seem to work
    { mods="SHIFT|ALT", key="]", action=wezterm.action{MoveTabRelative=1}},
    {key="{", mods="SHIFT|ALT", action=wezterm.action{MoveTabRelative=-1}},
    {key="}", mods="SHIFT|ALT", action=wezterm.action{MoveTabRelative=1}},
    { mods="SUPER", key="w", action=wezterm.action{CloseCurrentPane={confirm=true}}},
    { mods="SUPER", key="d", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    { mods="SUPER|SHIFT", key="d", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
  },
}

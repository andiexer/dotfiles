-- Catppuccin Mocha palette
-- Reference: https://github.com/catppuccin/catppuccin

local colors <const> = {
  -- Base Colors
  black = 0xff1e1e2e,
  white = 0xffcdd6f4,
  red = 0xfff38ba8,
  green = 0xffa6e3a1,
  blue = 0xff89b4fa,
  yellow = 0xfff9e2af,
  orange = 0xfffab387,
  magenta = 0xfff5c2e7,
  purple = 0xffcba6f7,
  other_purple = 0xffb4befe,
  cyan = 0xff94e2d5,
  grey = 0xff585b70,
  dirty_white = 0xffbac2de,
  dark_grey = 0xff313244,
  transparent = 0x00000000,

  -- UI Containers
  bar = {
    bg = 0xf4303048, -- heller violett-blauer Grundton, ~96% Deckkraft
    border = 0xff3a3b50, -- etwas hellerer Border
  },

  popup = {
    bg = 0xee1e1e2e,
    border = 0xff45475a,
  },

  slider = {
    bg = 0xdd1e1e2e,
    border = 0xff45475a,
  },

  -- Background Variants
  bg1 = 0xff1e1e2e,
  bg2 = 0xff313244,

  -- Utility: Apply alpha to any color
  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then
      return color
    end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}

return colors

local settings = require("config.settings")

sbar.bar({
  topmost = "window",
  height = settings.dimens.graphics.bar.height,
  color = settings.colors.bar.bg,
  padding_right = 0,
  padding_left = 0,
  --margin = settings.dimens.padding.bar,
  --corner_radius = settings.dimens.graphics.background.corner_radius,
  --y_offset = settings.dimens.graphics.bar.offset,
  blur_radius = settings.dimens.graphics.blur_radius,
  border_width = 0,
})

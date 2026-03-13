local constants = require("constants")
local settings = require("config.settings")

local calendar = sbar.add("item", constants.items.CALENDAR, {
  position = "right",
  update_freq = 1,
  icon = { padding_left = 0, padding_right = 0 },
  label = {
    color = settings.colors.purple,
    font = {
      family = settings.fonts.text,
      style = settings.fonts.styles.bold,
      size = settings.dimens.text.size,
    },
    padding_left = settings.dimens.padding.label,
    padding_right = settings.dimens.padding.icon,
  },
  background = {
    height = settings.dimens.graphics.bar.height,
    color = settings.colors.with_alpha(settings.colors.purple, 0.15),
    corner_radius = settings.dimens.graphics.background.corner_radius,
    padding_right = -settings.dimens.graphics.background.corner_radius,
  },
})

calendar:subscribe({ "forced", "routine", "system_woke" }, function(env)
  os.setlocale("de_DE.UTF-8") -- für deutsche Abkürzungen
  calendar:set({
    label = os.date("%d.%b %H:%M"),
  })
end)

calendar:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Calendar'")
end)

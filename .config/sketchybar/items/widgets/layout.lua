local constants = require("constants")
local settings = require("config.settings")

local mode_indicator = sbar.add("item", "sys.windowmode", {
  position = "right",
  icon = { drawing = false },
  label = {
    string = "󰙀",
    font = settings.fonts.icons(),
    color = settings.colors.purple,
    padding_left = 0,
  },
})

mode_indicator:subscribe("window_mode_changed", function(env)
  local is_floating = env.MODE == "floating"
  mode_indicator:set({
    label = {
      string = is_floating and "󰉶" or "󰙀",
      color = is_floating and settings.colors.yellow or settings.colors.purple,
    },
  })
end)

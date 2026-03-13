local settings = require("config.settings")

require("items.widgets.calendar")
sbar.add("item", { position = "right", width = 10, icon = { padding_left = 0, padding_right = 0 }, label = { padding_left = 0, padding_right = 0 } })
require("items.widgets.layout")
require("items.widgets.battery")
require("items.widgets.volume")
require("items.widgets.wifi")
require("items.widgets.pritunl")

local spacer = sbar.add("item", {
  position = "right",
  width = "10",
  label = {
    padding_right = settings.dimens.padding.label,
    padding_left = settings.dimens.padding.label,
  },
  icon = {
    padding_left = 0,
    padding_right = 0,
  },
})

require("items.widgets.stats")

local spacer = sbar.add("item", {
  position = "right",
  width = "10",
  label = {
    padding_right = settings.dimens.padding.label,
    padding_left = settings.dimens.padding.label,
  },
  icon = {
    padding_left = 0,
    padding_right = 0,
  },
})

require("items.widgets.pomodoro")

local sysbracket = sbar.add("bracket", "sysbracket", { "/sys\\..*/" }, {
  background = {
    height = 28,
    color = settings.colors.black,
  },
})

local statsBracket = sbar.add("bracket", "stats_bracket", { "/stats\\..*/" }, {
  background = {
    height = 28,
    color = settings.colors.black,
  },
})

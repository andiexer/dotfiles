local constants = require("constants")
local settings = require("config.settings")

local isShowingMenu = false

local apple = sbar.add("item", "galaxus", {
  icon = {
    color = settings.colors.purple,
    string = settings.icons.text.turtle,
    font = { size = 22 },
    padding_left = settings.dimens.padding.icon,
    padding_right = 4,
  },
  label = {
    font = {
      family = settings.fonts.text,
      style = settings.fonts.styles.bold,
      size = settings.dimens.text.icon,
    },
    color = settings.colors.purple,
    string = "DG",
    padding_left = 0,
    padding_right = settings.dimens.padding.label,
  },
  background = {
    height = settings.dimens.graphics.bar.height,
    color = settings.colors.with_alpha(settings.colors.purple, 0.15),
    corner_radius = settings.dimens.graphics.background.corner_radius,
    padding_left = -settings.dimens.graphics.background.corner_radius,
  },
})

local function closeMenus()
  isShowingMenu = false
  sbar.trigger(constants.events.SWAP_MENU_AND_SPACES, { isShowingMenu = "off" })
  apple:set({
    background = {
      color = settings.colors.with_alpha(settings.colors.purple, 0.15),
    },
  })
end

apple:subscribe("mouse.clicked", function(env)
  isShowingMenu = not isShowingMenu
  sbar.trigger(constants.events.SWAP_MENU_AND_SPACES, {
    isShowingMenu = isShowingMenu and "on" or "off",
  })
  apple:set({
    background = {
      color = settings.colors.with_alpha(settings.colors.purple, isShowingMenu and 0.35 or 0.15),
    },
  })
end)

apple:subscribe(constants.events.AEROSPACE_WORKSPACE_CHANGED, function(env)
  if isShowingMenu then
    closeMenus()
  end
end)

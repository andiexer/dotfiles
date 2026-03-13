local constants = require("constants")
local settings = require("config.settings")

local message = sbar.add("item", constants.items.MESSAGE, {
  width = 0,
  y_offset = -380, -- Position for notch displays
  position = "center",
  popup = {
    align = "center",
    height = 50,
  },
  label = {
    drawing = false,
  },
  icon = {
    drawing = false,
  },
  background = {
    color = settings.colors.transparent, -- Transparent background
    height = 0,
    border_width = 0,
  },
})

-- Title row (icon + title)
local messageTitle = sbar.add("item", "message.title", {
  position = "popup." .. message.name,
  width = 300,
  y_offset = 100,
  icon = {
    drawing = true,
    font = {
      style = settings.fonts.styles.regular,
      size = 24.0,
    },
    padding_left = 20,
    padding_right = 10,
  },
  label = {
    font = {
      style = settings.fonts.styles.bold,
      size = 17.0,
    },
    padding_right = 20,
    padding_left = 0,
    max_chars = 30,
  },
  background = {
    color = settings.colors.transparent,
    height = 20,
  },
})

-- Text row below
local messageText = sbar.add("item", "message.text", {
  position = "popup." .. message.name,
  width = 300,
  y_offset = 100,
  icon = { drawing = false },
  label = {
    font = {
      style = settings.fonts.styles.regular,
      size = 13.0,
    },
    padding_right = 20,
    padding_left = 56,  -- Indent to align with title
    color = settings.colors.dirty_white,
    max_chars = 50,
  },
  background = {
    color = settings.colors.transparent,
    height = 18,
  },
})

-- Bracket with shared background
local messageBracket = sbar.add("bracket", "message.bracket", { "message.title", "message.text" }, {
  background = {
    color = settings.colors.popup.bg,
    border_width = 0,
    corner_radius = 12,
    height = 80,
    padding_left = 10,
    padding_right = 10,
    shadow = {
      drawing = true,
      color = 0x80000000,
      angle = 90,
      distance = 8,
    },
  },
})

local function hideMessage()
  -- Slide out animation
  sbar.animate("tanh", 20, function()
    messageTitle:set({ y_offset = 100 })
    messageText:set({ y_offset = 100 })
    messageBracket:set({ y_offset = 100 })
  end)

  sbar.delay(0.3, function()
    message:set({ popup = { drawing = false } })
    messageTitle:set({
      icon = { string = "" },
      label = { string = "" },
    })
    messageText:set({
      label = { string = "" },
    })
  end)
end

local function showMessage(title, text, icon, iconColor, hold)
  -- Determine if text should be shown
  local hasText = text ~= nil and text ~= ""

  -- Reset to start position
  messageTitle:set({
    y_offset = 100,
    icon = {
      string = icon or "",
      color = iconColor or settings.colors.white,
    },
    label = { string = title or "" },
  })
  messageText:set({
    y_offset = 100,
    label = { string = text or "" },
    drawing = hasText,
  })
  messageBracket:set({ y_offset = 100 })

  -- Show popup
  message:set({ popup = { drawing = true } })

  -- Slide in animation - the card flies in from bottom
  sbar.animate("tanh", 30, function()
    messageTitle:set({ y_offset = 0 })
    messageText:set({ y_offset = 0 })
    messageBracket:set({ y_offset = 0 })
  end)

  if hold == false then
    sbar.delay(5, function()
      if hold then
        return
      end
      hideMessage()
    end)
  end
end

message:subscribe(constants.events.SEND_MESSAGE, function(env)
  local title = env.TITLE or env.MESSAGE -- Fallback to MESSAGE if no TITLE
  local text = env.TEXT or env.MESSAGE -- Optional text
  local icon = env.ICON
  local iconColor = env.ICON_COLOR
  local hold = env.HOLD or false
  showMessage(title, text, icon, iconColor, hold)
end)

message:subscribe(constants.events.HIDE_MESSAGE, hideMessage)

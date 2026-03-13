local constants = require("constants")
local settings = require("config.settings")

local switcher = sbar.add("item", "pomodoro_switcher", {
  position = "right",
  padding_left = 0,
  padding_right = 0,
  icon = {
    padding_left = 0,
    padding_right = 0,
    string = settings.icons.text.pomodoro.refresh,
  },
  label = {
    padding_left = 0,
    padding_right = 0,
  },
})

local timer = sbar.add("item", "pomodoro", {
  position = "right",
  update_freq = 1,
  padding_right = 0,
  icon = {
    string = settings.icons.text.pomodoro.done,
    color = settings.colors.red,
    padding_right = 0,
  },
  label = {
    string = "",
  },
})

local pomodoroBracket = sbar.add("bracket", "pomodoro_bracket", { timer.name, switcher.name }, {
  background = {
    height = 28,
    --border_color = settings.colors.purple,
    --border_width = 1,
    color = settings.colors.black,
  },
})

local pomodoroDuration = 25 * 60
local breakDuration = 5 * 60
local soundFile = "$CONFIG_DIR/bridge/sounds/uplifting.wav" -- Sound-Datei

local countdownTime = pomodoroDuration
local running = false
local onBreak = false
local soundPlayed = false -- Flag, um Sound nur einmal abzuspielen

timer:subscribe({ "mouse.clicked" }, function(env)
  if env.BUTTON == "right" then
    running = false
    countdownTime = pomodoroDuration
    soundPlayed = false
    onBreak = false
  elseif env.BUTTON == "left" then
    running = not running
    if running then
      soundPlayed = false
    end
  end
end)

switcher:subscribe({ "mouse.clicked" }, function(env)
  switchCycle()
end)

function switchCycle()
  onBreak = not onBreak
  if onBreak then
    countdownTime = breakDuration
  else
    countdownTime = pomodoroDuration
  end
  soundPlayed = false -- Reset für den Sound
end

function formatTime(seconds)
  local m = math.floor(seconds / 60)
  local s = seconds % 60
  return string.format("%02d:%02d", m, s)
end

-- ====== Countdown-Update ======
timer:subscribe({ "routine" }, function(env)
  if running then
    switcher:set({
      drawing = false,
    })
    if countdownTime > 0 then
      countdownTime = countdownTime - 1
    else
      -- Timer abgelaufen
      if not soundPlayed then
        os.execute("afplay " .. soundFile .. " &")
        soundPlayed = true

        -- Send notification
        local title = onBreak and "Pause beendet" or "Pomodoro beendet"
        local text = onBreak and "Zeit zum Arbeiten!" or "Zeit für eine Pause!"
        local icon = settings.icons.text.pomodoro.done
        local iconColor = onBreak and settings.colors.green or settings.colors.orange

        sbar.trigger(constants.events.SEND_MESSAGE, {
          TITLE = title,
          TEXT = text,
          ICON = icon,
          ICON_COLOR = iconColor,
        })
      end

      -- Wechsel zwischen Pomodoro / Pause
      running = false
      if not onBreak then
        onBreak = true
        countdownTime = breakDuration
        running = false
        soundPlayed = false -- reset für nächste Phase
      else
        onBreak = false
        countdownTime = pomodoroDuration
        running = false
        soundPlayed = false
      end
    end

    timer:set({
      label = { string = formatTime(countdownTime) },
      icon = { color = settings.colors.green },
    })
  else
    timer:set({
      label = { string = formatTime(countdownTime) },
      icon = { color = settings.colors.red },
    })
    switcher:set({
      drawing = true,
    })
  end
end)

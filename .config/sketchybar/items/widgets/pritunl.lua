local constants = require("constants")
local settings = require("config.settings")

-- Track previous state to detect changes
local previousState = nil

-- Pritunl VPN status widget
local pritunl = sbar.add("item", "sys.pritunl", {
  position = "right",
  label = { drawing = false },
  icon = {
    string = "󰖂", -- VPN shield icon
    color = settings.colors.magenta,
  },
  padding_right = 0,
  update_freq = 10, -- Check every 10 seconds
})

-- Function to check Pritunl connection status
local function checkPritunlStatus()
  -- Check all utun interfaces (Pritunl uses utun, but the number changes)
  sbar.exec("ifconfig 2>/dev/null | awk '/^utun/{iface=$1} /inet /{print iface, $2}' | grep -v '^$'", function(ip)
    local isConnected = not (ip == "")

    local vpnIcon = "󰖂" -- Shield icon
    local vpnColor

    if isConnected then
      vpnColor = settings.colors.green
    else
      vpnColor = settings.colors.magenta
    end

    pritunl:set({
      icon = {
        string = vpnIcon,
        color = vpnColor,
      },
    })

    -- Check if state has changed and send notification
    if previousState ~= nil and previousState ~= isConnected then
      local title = "Pritunl"
      local text = isConnected and "Verbindung hergestellt" or "Verbindung getrennt"
      local icon = "󰖂"  -- VPN shield icon
      local iconColor = isConnected and settings.colors.green or settings.colors.red
      sbar.trigger(constants.events.SEND_MESSAGE, {
        TITLE = title,
        TEXT = text,
        ICON = icon,
        ICON_COLOR = iconColor,
      })
    end

    -- Update previous state
    previousState = isConnected
  end)
end

-- Subscribe to events
pritunl:subscribe({ "routine", "system_woke", "forced" }, function(env)
  checkPritunlStatus()
end)

-- Initial check
checkPritunlStatus()

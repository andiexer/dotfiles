local constants = require("constants")
local settings = require("config.settings")

local popupWidth <const> = settings.dimens.graphics.popup.width + 40

local wifi = sbar.add("item", "sys.wifi", {
  position = "right",
  label = { drawing = false },
  padding_right = 0,
})

local ssid = sbar.add("item", {
  align = "center",
  position = "popup." .. wifi.name,
  width = popupWidth,
  height = 16,
  icon = {
    string = settings.icons.text.wifi.router,
    font = {
      style = settings.fonts.styles.bold,
    },
  },
  label = {
    font = {
      style = settings.fonts.styles.bold,
      size = settings.dimens.text.label,
    },
    string = "Network Configuration",
  },
})

local router = sbar.add("item", "router", {
  position = "popup." .. wifi.name,
  background = {
    height = 16,
  },
  icon = {
    align = "left",
    string = "Router:",
    width = popupWidth / 2,
    font = {
      size = settings.dimens.text.label,
    },
  },
  label = {
    align = "right",
    string = "???.???.???.???",
    width = popupWidth / 2,
  },
})

local ip = sbar.add("item", "ip", {
  position = "popup." .. wifi.name,
  background = {
    height = 16,
  },
  icon = {
    align = "left",
    string = "IP:",
    width = popupWidth / 2,
    font = {
      size = settings.dimens.text.label,
    },
  },
  label = {
    align = "right",
    string = "???.???.???.???",
    width = popupWidth / 2,
  },
})

wifi:subscribe({ "wifi_change", "system_woke", "forced" }, function(env)
  wifi:set({
    icon = {
      string = settings.icons.text.wifi.disconnected,
      color = settings.colors.magenta,
    },
  })

  sbar.exec([[ipconfig getifaddr en0]], function(ip)
    local ipConnected = not (ip == "")

    local wifiIcon
    local wifiColor

    if ipConnected then
      wifiIcon = settings.icons.text.wifi.connected
      wifiColor = settings.colors.white
    end

    wifi:set({
      icon = {
        string = wifiIcon,
        color = wifiColor,
      },
    })

    sbar.exec([[sleep 2; scutil --nwi | grep -m1 'utun' | awk '{ print $1 }']], function(vpn)
      local isVPNConnected = not (vpn == "")

      if isVPNConnected then
        wifiIcon = settings.icons.text.wifi.vpn
        wifiColor = settings.colors.green
      end

      wifi:set({
        icon = {
          string = wifiIcon,
          color = wifiColor,
        },
      })
    end)
  end)
end)

local function toggleDetails()
  wifi:set({ popup = { drawing = "toggle" } })

  sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'", function(result)
    router:set({ label = result })
  end)

  sbar.exec("ipconfig getifaddr en0", function(result)
    ip:set({ label = result })
  end)
end

local function dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. dump(v) .. ", "
    end
    return s .. "}"
  else
    return tostring(o)
  end
end

-- local function copyLabelToClipboard(env)
--   local dump = dump(env)
--   local asdf = sbar.
--   sbar.set(env.NAME, { label = "hodor" })
--   sbar.exec('echo "' .. print(sbar.query(env.Name)) .. '" | pbcopy')
--   end

wifi:subscribe("mouse.clicked", toggleDetails)
--ssid:subscribe("mouse.clicked", copyLabelToClipboard)
-- ip:subscribe("mouse.clicked", copyLabelToClipboard)
-- router:subscribe("mouse.clicked", copyLabelToClipboard)

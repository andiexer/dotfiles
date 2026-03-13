local settings = require("config.settings")

sbar.exec(
  "killall stats_provider >/dev/null; $CONFIG_DIR/bridge/stats_provider/stats_provider --cpu usage --memory ram_usage"
)

-- local cpuTemp = sbar.add("item", "stats.cputemp", {
--   position = "right",
--   update_freq = 5,
--   icon = {
--     string = settings.icons.text.temperature,
--   },
--   label = { string = "", padding_left = 0, padding_right = 8 },
-- })

local memory = sbar.add("item", "stats.memory", {
  position = "right",
  update_freq = 5,
  icon = {
    string = settings.icons.text.memory,
  },
  label = {
    padding_left = 0,
    padding_right = 8,
  },
})

local cpu = sbar.add("item", "stats.cpu", {
  position = "right",
  update_freq = 5,
  icon = {
    string = settings.icons.text.cpu,
  },
  label = { string = "", padding_left = 0, padding_right = 0 },
})

cpu:subscribe("system_stats", function(env)
  if env.CPU_USAGE then
    cpu:set({ label = env.CPU_USAGE })
  end
end)

memory:subscribe("system_stats", function(env)
  if env.RAM_USAGE then
    memory:set({ label = env.RAM_USAGE })
  end
end)

-- cpuTemp:subscribe("system_stats", function(env)
--   if env.CPU_TEMP then
--     cpuTemp:set({ label = env.CPU_TEMP })
--   end
-- end)

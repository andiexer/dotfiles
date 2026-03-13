local constants = require("constants")
local settings = require("config.settings")

local spaces = {}
local hasWindowsMap = {}
local frontAppPerSpace = {}
local frontAppNamePerSpace = {}
local focusedWorkspace = nil

local swapWatcher = sbar.add("item", { drawing = false, updates = true })
local currentWorkspaceWatcher = sbar.add("item", { drawing = false, updates = true })
local space_window_observer = sbar.add("item", { drawing = false, updates = true })
local frontAppWatcher = sbar.add("item", { drawing = false, updates = true })

local spaceConfigs = {
  ["1"] = { name = "1" },
  ["2"] = { name = "2" },
  ["3"] = { name = "3" },
  ["4"] = { name = "4" },
  ["5"] = { name = "5" },
  ["6"] = { name = "6" },
  ["7"] = { name = "7" },
  ["8"] = { name = "8" },
  ["9"] = { name = "9" },
}

local function appNameToIcon(appName)
  if not appName or appName == "" then
    return settings.icons.apps["default"]
  end
  return settings.icons.apps[appName] or settings.icons.apps["default"]
end

local function applySpaceStyle(key, isSelected, hasWin)
  local spaceName = key:match("workspaces%.(.+)")
  local appIcon = frontAppPerSpace[spaceName] or settings.icons.apps["default"]

  if isSelected then
    spaces[key]:set({
      icon = { color = settings.colors.bg1 },
      label = { drawing = true, string = appIcon, color = settings.colors.bg1 },
      background = { color = settings.colors.purple, border_width = 0 },
    })
  elseif hasWin then
    spaces[key]:set({
      icon = { color = 0xa6adc8c9 },
      label = { drawing = true, string = appIcon, color = 0xcdd6f4ff },
      background = { color = settings.colors.bg2, border_width = 0 },
    })
  else
    spaces[key]:set({
      icon = { color = settings.colors.grey },
      label = { drawing = false },
      background = { color = settings.colors.transparent, border_width = 0 },
    })
  end
end

local function selectCurrentWorkspace(focusedWorkspaceName)
  focusedWorkspace = focusedWorkspaceName
  for sid, item in pairs(spaces) do
    if item ~= nil then
      local isSelected = sid == constants.items.SPACES .. "." .. focusedWorkspaceName
      local spaceName = sid:match("workspaces%.(.+)")
      applySpaceStyle(sid, isSelected, hasWindowsMap[spaceName] or false)
    end
  end
end

local function addWorkspaceItem(workspaceName, isLast)
  local spaceName = constants.items.SPACES .. "." .. workspaceName
  local spaceConfig = spaceConfigs[workspaceName]
  spaces[spaceName] = sbar.add("item", spaceName, {
    label = {
      padding_left = 0,
      font = settings.fonts.icons(),
      string = settings.icons.apps["default"],
    },
    icon = {
      y_offset = 1,
      string = spaceConfig.name,
      color = 0xa6adc8c9,
      font = { style = "bold" },
    },
    background = { color = settings.colors.bg1, height = 20 },
    click_script = "aerospace workspace " .. workspaceName,
  })
  if not isLast then
    sbar.add("item", spaceName .. ".padding", {
      width = settings.dimens.padding.label,
    })
  end
end

local function updateWindowIndicators()
  sbar.exec("aerospace list-windows --all --format '%{workspace} %{app-name}'", function(output)
    hasWindowsMap = {}
    local firstAppPerSpace = {}
    local appsPerSpace = {}
    for line in output:gmatch("[^\r\n]+") do
      local ws, app = line:match("^(%S+)%s+(.+)$")
      if ws and app then
        hasWindowsMap[ws] = true
        if not firstAppPerSpace[ws] then
          firstAppPerSpace[ws] = app
        end
        if not appsPerSpace[ws] then appsPerSpace[ws] = {} end
        appsPerSpace[ws][app] = true
      end
    end
    -- Clear icons for workspaces that lost all windows
    for ws in pairs(frontAppPerSpace) do
      if not hasWindowsMap[ws] then
        frontAppPerSpace[ws] = nil
        frontAppNamePerSpace[ws] = nil
      end
    end
    -- Only update a workspace's icon if the app we're showing left that workspace
    for ws, app in pairs(firstAppPerSpace) do
      local current = frontAppNamePerSpace[ws]
      if not current or not (appsPerSpace[ws] and appsPerSpace[ws][current]) then
        frontAppNamePerSpace[ws] = app
        frontAppPerSpace[ws] = appNameToIcon(app)
      end
    end
    for _, space in pairs(spaceConfigs) do
      local key = constants.items.SPACES .. "." .. space.name
      local isSelected = focusedWorkspace == space.name
      applySpaceStyle(key, isSelected, hasWindowsMap[space.name] or false)
      sbar.set(key .. ".padding", { drawing = true })
    end
  end)
end

frontAppWatcher:subscribe(constants.events.FRONT_APP_SWITCHED, function(env)
  if focusedWorkspace and env.INFO then
    frontAppNamePerSpace[focusedWorkspace] = env.INFO
    frontAppPerSpace[focusedWorkspace] = appNameToIcon(env.INFO)
    local key = constants.items.SPACES .. "." .. focusedWorkspace
    if spaces[key] then
      applySpaceStyle(key, true, hasWindowsMap[focusedWorkspace] or true)
    end
  end
end)

space_window_observer:subscribe({ "update_windows", "update_spaces" }, function(env)
  updateWindowIndicators()
end)

currentWorkspaceWatcher:subscribe(constants.events.AEROSPACE_WORKSPACE_CHANGED, function(env)
  selectCurrentWorkspace(env.FOCUSED_WORKSPACE)
  sbar.trigger(constants.events.UPDATE_WINDOWS)
end)

swapWatcher:subscribe(constants.events.SWAP_MENU_AND_SPACES, function(env)
  local isShowingSpaces = env.isShowingMenu == "off" and true or false
  sbar.set("/" .. constants.items.SPACES .. "\\..*/", { drawing = isShowingSpaces })
end)

local function createWorkspaces()
  sbar.exec(constants.aerospace.LIST_ALL_WORKSPACES, function(workspacesOutput)
    sbar.add("item", constants.items.SPACES .. ".padding_left", {
      width = settings.dimens.padding.label,
      icon = { padding_left = 0, padding_right = 0 },
      label = { padding_left = 0, padding_right = 0 },
    })
    local workspaceNames = {}
    for workspaceName in workspacesOutput:gmatch("[^\r\n]+") do
      table.insert(workspaceNames, workspaceName)
    end
    for i, workspaceName in ipairs(workspaceNames) do
      addWorkspaceItem(workspaceName, i == #workspaceNames)
    end
    sbar.add("item", constants.items.SPACES .. ".padding_right", {
      width = settings.dimens.padding.label,
      icon = { padding_left = 0, padding_right = 0 },
      label = { padding_left = 0, padding_right = 0 },
    })
    sbar.add("bracket", "spaces_bracket", { "/" .. constants.items.SPACES .. "\\..*/", }, {
      background = {
        height = 28,
        color = settings.colors.black,
      },
    })
    sbar.exec(constants.aerospace.GET_CURRENT_WORKSPACE, function(output)
      focusedWorkspace = output:match("[^\r\n]+")
      updateWindowIndicators()
      selectCurrentWorkspace(focusedWorkspace)
    end)
  end)
end

createWorkspaces()

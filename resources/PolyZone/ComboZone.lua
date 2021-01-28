local mapMinX, mapMinY, mapMaxX, mapMaxY = -3700, -4400, 4500, 8000
local xDivisions = 34
local yDivisions = 50
local xDelta = (mapMaxX - mapMinX) / xDivisions
local yDelta = (mapMaxY - mapMinY) / yDivisions

ComboZone = {}

-- Finds all values in tblA that are not in tblB, using the "id" property
local function tblDifference(tblA, tblB)
  local diff
  for _, a in ipairs(tblA) do
    local found = false
    for _, b in ipairs(tblB) do
      if b.id == a.id then
        found = true
        break
      end
    end
    if not found then
      diff = diff or {}
      diff[#diff+1] = a
    end
  end
  return diff
end

local function _differenceBetweenInsideZones(insideZones, newInsideZones)
  local insideZonesCount, newInsideZonesCount = #insideZones, #newInsideZones
  if insideZonesCount == 0 and newInsideZonesCount == 0 then
    -- No zones to check
    return false, nil, nil
  elseif insideZonesCount == 0 and newInsideZonesCount > 0 then
    -- Was in no zones last check, but in 1 or more zones now (just entered all zones in newInsideZones)
    return true, copyTbl(newInsideZones), nil
  elseif insideZonesCount > 0 and newInsideZonesCount == 0 then
    -- Was in 1 or more zones last check, but in no zones now (just left all zones in insideZones)
    return true, nil, copyTbl(insideZones)
  end

  -- Check for zones that were in insideZones, but are not in newInsideZones (zones the player just left)
  local leftZones = tblDifference(insideZones, newInsideZones)
  -- Check for zones that are in newInsideZones, but were not in insideZones (zones the player just entered)
  local enteredZones = tblDifference(newInsideZones, insideZones)

  local isDifferent = enteredZones ~= nil or leftZones ~= nil
  return isDifferent, enteredZones, leftZones
end

local function _circleRectCollide(circleX, circleY, radius, rectX, rectY, rectWidth, rectLength)
  -- temporary variables to set edges for testing
  local testX = circleX
  local testY = circleY

  -- which edge is closest?
  if circleX < rectX then testX = rectX      					                    -- test left edge
  elseif circleX > rectX + rectWidth then testX = rectX + rectWidth end   -- right edge
  if circleY < rectY then testY = rectY     		                          -- top edge
  elseif circleY > rectY + rectLength then testY = rectY + rectLength end -- bottom edge

  -- get distance from closest edges
  local distX = circleX - testX
  local distY = circleY - testY

	return distX * distX + distY * distY < radius * radius
end

local function _addZoneToRows(rows, zone)
  local radius = zone.radius or zone.boundingRadius
  local minY = (zone.center.y - radius - mapMinY) // yDelta
  local maxY = (zone.center.y + radius - mapMinY) // yDelta
  for i=minY, maxY do
    local row = rows[i] or {}
    row[#row+1] = zone
    rows[i] = row
  end
end

local function _zonesInGridCell(x, y, zones)
  local zonesInCell = {}
  local startX = mapMinX + xDelta * x
  local startY = mapMinY + yDelta * y
  for _, zone in ipairs(zones) do
    -- For each zone, append to zonesInCell IF it is inside the grid cell at x,y
    local zoneCenter = zone.center
    local radius = zone.radius or zone.boundingRadius
    if _circleRectCollide(zoneCenter.x, zoneCenter.y, radius, startX, startY, xDelta, yDelta) then
      zonesInCell[#zonesInCell+1] = zone
    end
  end
  return zonesInCell
end

local function _getGridCell(pos)
  local x = (pos.x - mapMinX) // xDelta
  local y = (pos.y - mapMinY) // yDelta
  return x, y
end


function ComboZone:draw()
  local zones = self.zones
  for i=1, #zones do
    local zone = zones[i]
    if zone and not zone.destroyed then
      zone:draw()
    end
  end
end


local function _initDebug(zone, options)
  if options.debugBlip then zone:addDebugBlip() end
  if not options.debugPoly then
    return
  end
  
  Citizen.CreateThread(function()
    while not zone.destroyed do
      zone:draw()
      Citizen.Wait(0)
    end
  end)
end

function ComboZone:new(zones, options)
  options = options or {}
  local rows = {}
  -- Add a unique id for each zone in the ComboZone and add to rows cache
  for i=1, #zones do
    local zone = zones[i]
    if zone then
      zone.id = i
    end
    _addZoneToRows(rows, zone)
  end

  local useGrid = options.useGrid
  if useGrid == nil and #zones >= 25 then
    useGrid = true
  end
  local zone = {
    name = tostring(options.name) or nil,
    zones = zones,
    useGrid = useGrid,
    rows = rows,
    grid = {},
    debugPoly = options.debugPoly or false,
    data = options.data or {},
    isComboZone = true,
  }
  setmetatable(zone, self)
  self.__index = self
  return zone
end

function ComboZone:Create(zones, options)
  local zone = ComboZone:new(zones, options)
  _initDebug(zone, options)
  AddEventHandler("polyzone:pzcomboinfo", function ()
      zone:printInfo()
  end)
  return zone
end

function ComboZone:getZones(point)
  if not self.useGrid then
    return self.zones
  end
  
  local grid = self.grid
  local gridX, gridY = _getGridCell(point)
  local row = grid[gridY]
  if row == nil then
    row = {}
  end
  if row[gridX] == nil then
    local zonesInCell = _zonesInGridCell(gridX, gridY, self.rows[gridY] or {})
    row[gridX] = zonesInCell
    grid[gridY] = row
  end
  return grid[gridY][gridX]
end

function ComboZone:AddZone(zone)
  local zones = self.zones
  local newIndex = #zones+1
  zone.id = newIndex
  zones[newIndex] = zone
  self.grid = {}
  _addZoneToRows(self.rows, zone)
  if self.useGrid == nil and newIndex >= 25 then
    self.useGrid = true
  end
  if self.debugBlip then zone:addDebugBlip() end
end

function ComboZone:isPointInside(point)
  if self.destroyed then
    print("[PolyZone] Warning: Called isPointInside on destroyed zone {name=" .. self.name .. "}")
    return false, {}
  end

  local zones = self:getZones(point)
  if #zones == 0 then return false end

  for i=1, #zones do
    local zone = zones[i]
    if zone and zone:isPointInside(point) then
      return true, zone
    end
  end
  return false, nil
end

function ComboZone:isPointInsideExhaustive(point, insideZones)
  if self.destroyed then
    print("[PolyZone] Warning: Called isPointInside on destroyed zone {name=" .. self.name .. "}")
    return false, {}
  end

  if insideZones ~= nil then
    insideZones = clearTbl(insideZones)
  else
    insideZones = {}
  end
  local zones = self:getZones(point)
  if #zones == 0 then return false, insideZones end
  for i=1, #zones do
    local zone = zones[i]
    if zone and zone:isPointInside(point) then
      insideZones[#insideZones+1] = zone
    end
  end
  return #insideZones > 0, insideZones
end

function ComboZone:destroy()
  PolyZone.destroy(self)
  local zones = self.zones
  for i=1, #zones do
    local zone = zones[i]
    if zone and not zone.destroyed then
      zone:destroy()
    end
  end
end

function ComboZone:onPointInOut(getPointCb, onPointInOutCb, waitInMS)
  -- Localize the waitInMS value for performance reasons (default of 500 ms)
  local _waitInMS = 500
  if waitInMS ~= nil then _waitInMS = waitInMS end

  Citizen.CreateThread(function()
    local isInside = nil
    local insideZone = nil
    while not self.destroyed do
      if not self.paused then
        local point = getPointCb()
        local newIsInside, newInsideZone = self:isPointInside(point)
        if newIsInside ~= isInside then
          onPointInOutCb(newIsInside, point, newInsideZone or insideZone)
          isInside = newIsInside
          insideZone = newInsideZone
        end
      end
      Citizen.Wait(_waitInMS)
    end
  end)
end

function ComboZone:onPointInOutExhaustive(getPointCb, onPointInOutCb, waitInMS)
  -- Localize the waitInMS value for performance reasons (default of 500 ms)
  local _waitInMS = 500
  if waitInMS ~= nil then _waitInMS = waitInMS end

  Citizen.CreateThread(function()
    local isInside, insideZones = nil, {}
    local newIsInside, newInsideZones = nil, {}
    while not self.destroyed do
      if not self.paused then
        local point = getPointCb()
        newIsInside, newInsideZones = self:isPointInsideExhaustive(point, newInsideZones)
        local isDifferent, enteredZones, leftZones = _differenceBetweenInsideZones(insideZones, newInsideZones)
        if newIsInside ~= isInside or isDifferent then
          isInside = newIsInside
          insideZones = copyTbl(newInsideZones)
          onPointInOutCb(isInside, point, insideZones, enteredZones, leftZones)
        end
      end
      Citizen.Wait(_waitInMS)
    end
  end)
end

function ComboZone:onPlayerInOut(onPointInOutCb, waitInMS)
  self:onPointInOut(PolyZone.getPlayerPosition, onPointInOutCb, waitInMS)
end

function ComboZone:onPlayerInOutExhaustive(onPointInOutCb, waitInMS)
  self:onPointInOutExhaustive(PolyZone.getPlayerPosition, onPointInOutCb, waitInMS)
end

function ComboZone:addDebugBlip()
  self.debugBlip = true
  local zones = self.zones
  for i=1, #zones do
    local zone = zones[i]
    if zone then zone:addDebugBlip() end
  end
end

function ComboZone:printInfo()
  local zones = self.zones
  local polyCount, boxCount, circleCount, entityCount, comboCount = 0, 0, 0, 0, 0
  for i=1, #zones do
    local zone = zones[i]
    if zone then
      if zone.isEntityZone then entityCount = entityCount + 1
      elseif zone.isCircleZone then circleCount = circleCount + 1
      elseif zone.isComboZone then comboCount = comboCount + 1
      elseif zone.isBoxZone then boxCount = boxCount + 1
      elseif zone.isPolyZone then polyCount = polyCount + 1 end
    end
  end
  local name = self.name ~= nil and ("\"" .. self.name .. "\"") or nil
  print("-----------------------------------------------------")
  print("[PolyZone] Info for ComboZone { name = " .. tostring(name) .. " }:")
  print("[PolyZone]   Total zones: " .. #zones)
  if boxCount > 0 then print("[PolyZone]   BoxZones: " .. boxCount) end
  if circleCount > 0 then print("[PolyZone]   CircleZones: " .. circleCount) end
  if polyCount > 0 then print("[PolyZone]   PolyZones: " .. polyCount) end
  if entityCount > 0 then print("[PolyZone]   EntityZones: " .. entityCount) end
  if comboCount > 0 then print("[PolyZone]   ComboZones: " .. comboCount) end
  print("-----------------------------------------------------")
end

function ComboZone:setPaused(paused)
  self.paused = paused
end

function ComboZone:isPaused()
  return self.paused
end

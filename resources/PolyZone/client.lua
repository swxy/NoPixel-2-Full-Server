local defaultColorWalls = {0, 255, 0}
local defaultColorOutline = {255, 0, 0}
local defaultColorGrid = {255, 255, 255}

PolyZone = {}

-- Utility functions
local abs = math.abs
local function _isLeft(p0, p1, p2)
  local p0x = p0.x
  local p0y = p0.y
  return ((p1.x - p0x) * (p2.y - p0y)) - ((p2.x - p0x) * (p1.y - p0y))
end

local function _wn_inner_loop(p0, p1, p2, wn)
  local p2y = p2.y
  if (p0.y <= p2y) then
    if (p1.y > p2y) then
      if (_isLeft(p0, p1, p2) > 0) then
        return wn + 1
      end
    end
  else
    if (p1.y <= p2y) then
      if (_isLeft(p0, p1, p2) < 0) then
        return wn - 1
      end
    end
  end
  return wn
end

function addBlip(pos)
  local blip = AddBlipForCoord(pos.x, pos.y, 0.0)
  SetBlipColour(blip, 7)
  SetBlipDisplay(blip, 8)
  SetBlipScale(blip, 1.0)
  SetBlipAsShortRange(blip, true)
  return blip
end

function clearTbl(tbl)
  -- Only works with contiguous (array-like) tables
  if tbl == nil then return end
  for i=1, #tbl do
    tbl[i] = nil
  end
  return tbl
end

function copyTbl(tbl)
  -- Only a shallow copy, and only works with contiguous (array-like) tables
  if tbl == nil then return end
  local ret = {}
  for i=1, #tbl do
    ret[i] = tbl[i]
  end
  return ret
end

-- Winding Number Algorithm - http://geomalgorithms.com/a03-_inclusion.html
local function _windingNumber(point, poly)
  local wn = 0 -- winding number counter

  -- loop through all edges of the polygon
  for i = 1, #poly - 1 do
    wn = _wn_inner_loop(poly[i], poly[i + 1], point, wn)
  end
  -- test last point to first point, completing the polygon
  wn = _wn_inner_loop(poly[#poly], poly[1], point, wn)

  -- the point is outside only when this winding number wn===0, otherwise it's inside
  return wn ~= 0
end

-- Detects intersection between two lines
local function _isIntersecting(a, b, c, d)
  -- Store calculations in local variables for performance
  local ax_minus_cx = a.x - c.x
  local bx_minus_ax = b.x - a.x
  local dx_minus_cx = d.x - c.x
  local ay_minus_cy = a.y - c.y
  local by_minus_ay = b.y - a.y
  local dy_minus_cy = d.y - c.y
  local denominator = ((bx_minus_ax) * (dy_minus_cy)) - ((by_minus_ay) * (dx_minus_cx))
  local numerator1 = ((ay_minus_cy) * (dx_minus_cx)) - ((ax_minus_cx) * (dy_minus_cy))
  local numerator2 = ((ay_minus_cy) * (bx_minus_ax)) - ((ax_minus_cx) * (by_minus_ay))

  -- Detect coincident lines
  if denominator == 0 then return numerator1 == 0 and numerator2 == 0 end

  local r = numerator1 / denominator
  local s = numerator2 / denominator

  return (r >= 0 and r <= 1) and (s >= 0 and s <= 1)
end

-- https://rosettacode.org/wiki/Shoelace_formula_for_polygonal_area#Lua
local function _calculatePolygonArea(points)
  local function det2(i,j)
    return points[i].x*points[j].y-points[j].x*points[i].y
  end
  local sum = #points>2 and det2(#points,1) or 0
  for i=1,#points-1 do sum = sum + det2(i,i+1)end
  return abs(0.5 * sum)
end


-- Debug drawing functions
function _drawWall(p1, p2, minZ, maxZ, r, g, b, a)
  local bottomLeft = vector3(p1.x, p1.y, minZ)
  local topLeft = vector3(p1.x, p1.y, maxZ)
  local bottomRight = vector3(p2.x, p2.y, minZ)
  local topRight = vector3(p2.x, p2.y, maxZ)
  
  DrawPoly(bottomLeft,topLeft,bottomRight,r,g,b,a)
  DrawPoly(topLeft,topRight,bottomRight,r,g,b,a)
  DrawPoly(bottomRight,topRight,topLeft,r,g,b,a)
  DrawPoly(bottomRight,topLeft,bottomLeft,r,g,b,a)
end

function PolyZone:TransformPoint(point)
  -- No point transform necessary for regular PolyZones, unlike zones like Entity Zones, whose points can be rotated and offset
  return point
end

function PolyZone:draw()
  local zDrawDist = 45.0
  local oColor = self.debugColors.outline or defaultColorOutline
  local oR, oG, oB = oColor[1], oColor[2], oColor[3]
  local wColor = self.debugColors.walls or defaultColorWalls
  local wR, wG, wB = wColor[1], wColor[2], wColor[3]
  local plyPed = PlayerPedId()
  local plyPos = GetEntityCoords(plyPed)
  local minZ = self.minZ or plyPos.z - zDrawDist
  local maxZ = self.maxZ or plyPos.z + zDrawDist
  
  local points = self.points
  for i=1, #points do
    local point = self:TransformPoint(points[i])
    DrawLine(point.x, point.y, minZ, point.x, point.y, maxZ, oR, oG, oB, 164)

    if i < #points then
      local p2 = self:TransformPoint(points[i+1])
      DrawLine(point.x, point.y, maxZ, p2.x, p2.y, maxZ, oR, oG, oB, 184)
      _drawWall(point, p2, minZ, maxZ, wR, wG, wB, 48)
    end
  end

  if #points > 2 then
    local firstPoint = self:TransformPoint(points[1])
    local lastPoint = self:TransformPoint(points[#points])
    DrawLine(firstPoint.x, firstPoint.y, maxZ, lastPoint.x, lastPoint.y, maxZ, oR, oG, oB, 184)
    _drawWall(firstPoint, lastPoint, minZ, maxZ, wR, wG, wB, 48)
  end
end

function PolyZone.drawPoly(poly)
  PolyZone.draw(poly)
end

-- Debug drawing all grid cells that are completly within the polygon
local function _drawGrid(poly)
  local minZ = poly.minZ
  local maxZ = poly.maxZ
  if not minZ or not maxZ then
    local plyPed = PlayerPedId()
    local plyPos = GetEntityCoords(plyPed)
    minZ = plyPos.z - 46.0
    maxZ = plyPos.z - 45.0
  end

  local lines = poly.lines
  local color = poly.debugColors.grid or defaultColorGrid
  local r, g, b = color[1], color[2], color[3]
  for i=1, #lines do
    local line = lines[i]
    local min = line.min
    local max = line.max
    DrawLine(min.x + 0.0, min.y + 0.0, maxZ + 0.0, max.x + 0.0, max.y + 0.0, maxZ + 0.0, r, g, b, 196)
  end
end


local function _pointInPoly(point, poly)
  local x = point.x
  local y = point.y
  local min = poly.min
  local minX = min.x
  local minY = min.y
  local max = poly.max

  -- Checks if point is within the polygon's bounding box
  if x < minX or
     x > max.x or
     y < minY or
     y > max.y then
      return false
  end

  -- Checks if point is within the polygon's height bounds
  local minZ = poly.minZ
  local maxZ = poly.maxZ
  local z = point.z
  if (minZ and z < minZ) or (maxZ and z > maxZ) then
    return false
  end

  -- Returns true if the grid cell associated with the point is entirely inside the poly
  if poly.grid then
    local gridDivisions = poly.gridDivisions
    local size = poly.size
    local gridPosX = x - minX
    local gridPosY = y - minY
    local gridCellX = (gridPosX * gridDivisions) // size.x
    local gridCellY = (gridPosY * gridDivisions) // size.y
    if (poly.grid[gridCellY + 1][gridCellX + 1]) then return true end
  end

  return _windingNumber(point, poly.points)
end


-- Grid creation functions
-- Calculates the points of the rectangle that make up the grid cell at grid position (cellX, cellY)
local function _calculateGridCellPoints(cellX, cellY, poly)
  local gridCellWidth = poly.gridCellWidth
  local gridCellHeight = poly.gridCellHeight
  local min = poly.min
  -- min added to initial point, in order to shift the grid cells to the poly's starting position
  local x = cellX * gridCellWidth + min.x
  local y = cellY * gridCellHeight + min.y
  return {
    vector2(x, y),
    vector2(x + gridCellWidth, y),
    vector2(x + gridCellWidth, y + gridCellHeight),
    vector2(x, y + gridCellHeight),
    vector2(x, y)
  }
end


local function _isGridCellInsidePoly(cellX, cellY, poly)
  gridCellPoints = _calculateGridCellPoints(cellX, cellY, poly)
  local polyPoints = {table.unpack(poly.points)}
  -- Connect the polygon to its starting point
  polyPoints[#polyPoints + 1] = polyPoints[1]

  -- If none of the points of the grid cell are in the polygon, the grid cell can't be in it
  local isOnePointInPoly = false
  for i=1, #gridCellPoints - 1 do
    local cellPoint = gridCellPoints[i]
    local x = cellPoint.x
    local y = cellPoint.y
    if _windingNumber(cellPoint, poly.points) then
      isOnePointInPoly = true
      -- If we are drawing the grid (poly.lines ~= nil), we need to go through all the points,
      -- and therefore can't break out of the loop early
      if poly.lines then
        if not poly.gridXPoints[x] then poly.gridXPoints[x] = {} end
        if not poly.gridYPoints[y] then poly.gridYPoints[y] = {} end
        poly.gridXPoints[x][y] = true
        poly.gridYPoints[y][x] = true
      else break end
    end
  end
  if isOnePointInPoly == false then
    return false
  end

  -- If any of the grid cell's lines intersects with any of the polygon's lines
  -- then the grid cell is not completely within the poly
  for i=1, #gridCellPoints - 1 do
    local gridCellP1 = gridCellPoints[i]
    local gridCellP2 = gridCellPoints[i+1]
    for j=1, #polyPoints - 1 do
      if _isIntersecting(gridCellP1, gridCellP2, polyPoints[j], polyPoints[j+1]) then
        return false
      end
    end
  end
  
  return true
end


local function _calculateLinesForDrawingGrid(poly)
  local lines = {}
  for x, tbl in pairs(poly.gridXPoints) do
    local yValues = {}
    -- Turn dict/set of values into array
    for y, _ in pairs(tbl) do yValues[#yValues + 1] = y end
    if #yValues >= 2 then
      table.sort(yValues)
      local minY = yValues[1]
      local lastY = yValues[1]
      for i=1, #yValues do
        local y = yValues[i]
        -- Checks for breaks in the grid. If the distance between the last value and the current one
        -- is greater than the size of a grid cell, that means the line between them must go outside the polygon.
        -- Therefore, a line must be created between minY and the lastY, and a new line started at the current y
        if y - lastY > poly.gridCellHeight + 0.01 then
          lines[#lines+1] = {min=vector2(x, minY), max=vector2(x, lastY)}
          minY = y
        elseif i == #yValues then
          -- If at the last point, create a line between minY and the last point
          lines[#lines+1] = {min=vector2(x, minY), max=vector2(x, y)}
        end
        lastY = y
      end
    end
  end
  -- Setting nil to allow the GC to clear it out of memory, since we no longer need this
  poly.gridXPoints = nil

  -- Same as above, but for gridYPoints instead of gridXPoints
  for y, tbl in pairs(poly.gridYPoints) do
    local xValues = {}
    for x, _ in pairs(tbl) do xValues[#xValues + 1] = x end
    if #xValues >= 2 then
      table.sort(xValues)
      local minX = xValues[1]
      local lastX = xValues[1]
      for i=1, #xValues do
        local x = xValues[i]
        if x - lastX > poly.gridCellWidth + 0.01 then
          lines[#lines+1] = {min=vector2(minX, y), max=vector2(lastX, y)}
          minX = x
        elseif i == #xValues then
          lines[#lines+1] = {min=vector2(minX, y), max=vector2(x, y)}
        end
        lastX = x
      end
    end
  end
  poly.gridYPoints = nil
  return lines
end


-- Calculate for each grid cell whether it is entirely inside the polygon, and store if true
local function _createGrid(poly, options)
  Citizen.CreateThread(function()
    -- Calculate all grid cells that are entirely inside the polygon
    local isInside = {}
    local gridCellArea = poly.gridCellWidth * poly.gridCellHeight
    for y=1, poly.gridDivisions do
      Citizen.Wait(0)
      isInside[y] = {}
      for x=1, poly.gridDivisions do
        if _isGridCellInsidePoly(x-1, y-1, poly) then
          poly.gridArea = poly.gridArea + gridCellArea
          isInside[y][x] = true
        end
      end
    end
    poly.grid = isInside
    poly.gridCoverage = poly.gridArea / poly.area
    -- A lot of memory is used by this pre-calc. Force a gc collect after to clear it out
    collectgarbage("collect")

    if options.debugGrid then
      local coverage = string.format("%.2f", poly.gridCoverage * 100)
      print("[PolyZone] Debug: Grid Coverage at " .. coverage .. "% with " .. poly.gridDivisions
      .. " divisions. Optimal coverage for memory usage and startup time is 80-90%")

      Citizen.CreateThread(function()
        poly.lines = _calculateLinesForDrawingGrid(poly)
        -- A lot of memory is used by this pre-calc. Force a gc collect after to clear it out
        collectgarbage("collect")
      end)
    end
  end)
end


-- Initialization functions
local function _calculatePoly(poly, options)
  local minX, minY = math.maxinteger, math.maxinteger
  local maxX, maxY = math.mininteger, math.mininteger
  for _, p in ipairs(poly.points) do
    minX = math.min(minX, p.x)
    minY = math.min(minY, p.y)
    maxX = math.max(maxX, p.x)
    maxY = math.max(maxY, p.y)
  end

  poly.max = vector2(maxX, maxY)
  poly.min = vector2(minX, minY)
  poly.size = poly.max - poly.min
  poly.boundingRadius = math.sqrt(poly.size.y * poly.size.y + poly.size.x * poly.size.x) / 2
  poly.center = (poly.max + poly.min) / 2
  poly.area = _calculatePolygonArea(poly.points)
  if poly.useGrid then
    if options.debugGrid then
      poly.gridXPoints = {}
      poly.gridYPoints = {}
      poly.lines = {}
    end
    poly.gridArea = 0.0
    poly.gridCellWidth = poly.size.x / poly.gridDivisions
    poly.gridCellHeight = poly.size.y / poly.gridDivisions
    _createGrid(poly, options)
  end
end


local function _initDebug(poly, options)
  if options.debugBlip then poly:addDebugBlip() end
  local debugEnabled = options.debugPoly or options.debugGrid
  if not debugEnabled then
    return
  end
  
  Citizen.CreateThread(function()
    while not poly.destroyed do
      poly:draw()
      if options.debugGrid and poly.lines then
        _drawGrid(poly)
      end
      Citizen.Wait(0)
    end
  end)
end

function PolyZone:new(points, options)
  if not points then
    print("[PolyZone] Error: Passed nil points table to PolyZone:Create() {name=" .. options.name .. "}")
    return
  end
  if #points < 3 then
    print("[PolyZone] Warning: Passed points table with less than 3 points to PolyZone:Create() {name=" .. options.name .. "}")
  end

  options = options or {}
  local useGrid = options.useGrid
  if useGrid == nil then useGrid = true end
  local poly = {
    name = tostring(options.name) or nil,
    points = points,
    center = vector2(0, 0),
    size = vector2(0, 0),
    max = vector2(0, 0),
    min = vector2(0, 0),
    minZ = tonumber(options.minZ) or nil,
    maxZ = tonumber(options.maxZ) or nil,
    useGrid = useGrid,
    gridDivisions = tonumber(options.gridDivisions) or 30,
    debugColors = options.debugColors or {},
    debugPoly = options.debugPoly or false,
    debugGrid = options.debugGrid or false,
    data = options.data or {},
    isPolyZone = true,
  }
  _calculatePoly(poly, options)
  setmetatable(poly, self)
  self.__index = self
  return poly
end

function PolyZone:Create(points, options)
  local poly = PolyZone:new(points, options)
  _initDebug(poly, options)
  return poly
end

function PolyZone:isPointInside(point)
  if self.destroyed then
    print("[PolyZone] Warning: Called isPointInside on destroyed zone {name=" .. self.name .. "}")
    return false 
  end

  return _pointInPoly(point, self)
end

function PolyZone:destroy()
  self.destroyed = true
  if self.debugPoly or self.debugGrid then
    print("[PolyZone] Debug: Destroying zone {name=" .. self.name .. "}")
  end
end

-- Helper functions
function PolyZone.getPlayerPosition()
  return GetEntityCoords(PlayerPedId())
end

HeadBone = 0x796e;
function PolyZone.getPlayerHeadPosition()
  return GetPedBoneCoords(PlayerPedId(), HeadBone);
end

function PolyZone.ensureMetatable(zone)
  if zone.isComboZone then
    setmetatable(zone, ComboZone)
  elseif zone.isEntityZone then
    setmetatable(zone, EntityZone)
  elseif zone.isBoxZone then
    setmetatable(zone, BoxZone)
  elseif zone.isCircleZone then
    setmetatable(zone, CircleZone)
  elseif zone.isPolyZone then
    setmetatable(zone, PolyZone)
  end
end

function PolyZone:onPointInOut(getPointCb, onPointInOutCb, waitInMS)
  -- Localize the waitInMS value for performance reasons (default of 500 ms)
  local _waitInMS = 500
  if waitInMS ~= nil then _waitInMS = waitInMS end

  Citizen.CreateThread(function()
    local isInside = nil
    while not self.destroyed do
      if not self.paused then
        local point = getPointCb()
        local newIsInside = self:isPointInside(point)
        if newIsInside ~= isInside then
          onPointInOutCb(newIsInside, point)
          isInside = newIsInside
        end
      end
      Citizen.Wait(_waitInMS)
    end
  end)
end

function PolyZone:onPlayerInOut(onPointInOutCb, waitInMS)
  self:onPointInOut(PolyZone.getPlayerPosition, onPointInOutCb, waitInMS)
end

function PolyZone:addDebugBlip()
  return addBlip(self.center or self:getBoundingBoxCenter())
end

function PolyZone:setPaused(paused)
  self.paused = paused
end

function PolyZone:isPaused()
  return self.paused
end

function PolyZone:getBoundingBoxMin()
  return self.min
end

function PolyZone:getBoundingBoxMax()
  return self.max
end

function PolyZone:getBoundingBoxSize()
  return self.size
end

function PolyZone:getBoundingBoxCenter()
  return self.center
end

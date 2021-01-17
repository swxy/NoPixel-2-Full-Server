PolyZone = {}


local function _drawPoly(shape, opt)
  opt = opt or {}
  local zDrawDist = 75.0
  local plyPed = PlayerPedId()
  local plyPos = GetEntityCoords(plyPed)
  local minZ = shape.minZ or plyPos.z - zDrawDist
  local maxZ = shape.maxZ or plyPos.z + zDrawDist
  for i=1, #shape.points do
    if opt.drawPoints then
      DrawLine(shape.points[i].x, shape.points[i].y, minZ, shape.points[i].x, shape.points[i].y, maxZ, 255, 0, 0, 255)
    end
    if i < #shape.points then
      for j = minZ, maxZ, opt.lineSepDist or 5.0 do
        DrawLine(shape.points[i].x, shape.points[i].y, j, shape.points[i+1].x, shape.points[i+1].y, j, 0, 255, 0, 255)
      end
      DrawLine(shape.points[i].x, shape.points[i].y, maxZ, shape.points[i+1].x, shape.points[i+1].y, maxZ, 0, 255, 0, 255)
    end
  end

  if #shape.points > 2 then
    for j = minZ, maxZ, opt.lineSepDist or 5.0 do
      DrawLine(shape.points[#shape.points].x, shape.points[#shape.points].y, j, shape.points[1].x, shape.points[1].y, j, 0, 255, 0, 255)
    end
    DrawLine(shape.points[#shape.points].x, shape.points[#shape.points].y, maxZ, shape.points[1].x, shape.points[1].y, maxZ, 0, 255, 0, 255)
  end
end


function PolyZone.drawPoly(shape, opt)
  _drawPoly(shape, opt)
end

-- Debug drawing all grid cells that are completly within the polygon
local function _drawGrid(poly)
  local minZ = poly.minZ
  local maxZ = poly.maxZ
  if not minZ or not maxZ then
    local plyPed = PlayerPedId()
    local plyPos = GetEntityCoords(plyPed)
    minZ = plyPos.z - 76.0
    maxZ = plyPos.z - 75.0
  end

  local lines = poly.lines
  for i=1, #lines do
    local line = lines[i]
    local min = line.min
    local max = line.max
    DrawLine(min.x + 0.0, min.y + 0.0, maxZ + 0.0, max.x + 0.0, max.y + 0.0, maxZ + 0.0, 255, 255, 255, 255)
  end
end


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
  if minZ and maxZ and (z < minZ or z > maxZ) then
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

-- Detects intersection between two lines
local function _isIntersecting(a, b, c, d)
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


-- Calculates the points of the rectangle that make up the grid cell at grid position (cellX, cellY)
local function _calculateGridCellPoints(cellX, cellY, poly)
  local gridCellWidth = poly.gridCellWidth
  local gridCellHeight = poly.gridCellHeight
  local x = cellX * gridCellWidth
  local y = cellY * gridCellHeight
  local min = poly.min
  -- poly.min must be added to all the points, in order to shift the grid cell to poly's starting position
  return {
    vector2(x, y) + min,
    vector2(x + gridCellWidth, y) + min,
    vector2(x + gridCellWidth, y + gridCellHeight) + min,
    vector2(x, y + gridCellHeight) + min,
    vector2(x, y) + min
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


local function _calculateLinesForDrawingGrid(shape)
  local lines = {}
  for x, tbl in pairs(shape.gridXPoints) do
    local count = 1
    local yValues = {}
    -- Turn dict/set of values into array
    for y, _ in pairs(tbl) do yValues[count] = y; count = count + 1 end
    if count >= 2 then
      table.sort(yValues)
      local minY = yValues[1]
      local lastY = yValues[1]
      for i=1, #yValues do
        local y = yValues[i]
        -- Checks for breaks in the grid. If the distance between the last value and the current one
        -- is greater than the size of a grid cell, that means the line between them must go outside the polygon.
        -- Therefore, a line must be created between minY and the lastY, and a new line started at the current y
        if y - lastY > shape.gridCellHeight + 0.01 then
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
  shape.gridXPoints = nil

  -- Exactly the same as above, but for gridYPoints instead of gridXPoints
  for y, tbl in pairs(shape.gridYPoints) do
    local count = 1
    local xValues = {}
    for x, _ in pairs(tbl) do xValues[count] = x; count = count + 1 end
    if count >= 2 then
      table.sort(xValues)
      local minX = xValues[1]
      local lastX = xValues[1]
      for i=1, #xValues do
        local x = xValues[i]
        if x - lastX > shape.gridCellWidth + 0.01 then
          lines[#lines+1] = {min=vector2(minX, y), max=vector2(lastX, y)}
          minX = x
        elseif i == #xValues then
          lines[#lines+1] = {min=vector2(minX, y), max=vector2(x, y)}
        end
        lastX = x
      end
    end
  end
  shape.gridYPoints = nil
  return lines
end


-- Calculate for each grid cell whether it is entirely inside the polygon, and store if true
local function _createGrid(shape, options)
  Citizen.CreateThread(function()
  -- Calculate all grid cells that are entirely inside the polygon
  local isInside = {}
  for y=1, shape.gridDivisions do
    Citizen.Wait(0)
    isInside[y] = {}
    for x=1, shape.gridDivisions do
      if _isGridCellInsidePoly(x-1, y-1, shape) then
        shape.gridArea = shape.gridArea + shape.gridCellWidth * shape.gridCellHeight
        isInside[y][x] = true
      end
    end
  end
  shape.grid = isInside
  shape.gridCoverage = shape.gridArea / shape.area
  -- A lot of memory is used by this pre-calc. Force a gc collect after to clear it out
  collectgarbage("collect")

  if options.debugGrid then
    Citizen.CreateThread(function()
      shape.lines = _calculateLinesForDrawingGrid(shape)
      -- A lot of memory is used by this pre-calc. Force a gc collect after to clear it out
      collectgarbage("collect")
    end)
  end
  
  end)
end


-- https://rosettacode.org/wiki/Shoelace_formula_for_polygonal_area#Lua
function _calculatePolygonArea(points)
  local function det2(i,j)
    return points[i].x*points[j].y-points[j].x*points[i].y
  end
  local sum = #points>2 and det2(#points,1) or 0
  for i=1,#points-1 do sum = sum + det2(i,i+1)end
  return math.abs(0.5 * sum)
end


local function _calculateShape(shape, options)
  local totalX = 0.0
  local totalY = 0.0
  local maxX
  local maxY
  local minX
  local minY
  for i, p in ipairs(shape.points) do
    if not maxX or p.x > maxX then
      maxX = p.x
    end
    if not maxY or p.y > maxY then
      maxY = p.y
    end
    if not minX or p.x < minX then
      minX = p.x
    end
    if not minY or p.y < minY then
      minY = p.y
    end

    totalX = totalX + p.x
    totalY = totalY + p.y
  end

  shape.max = vector2(maxX, maxY)
  shape.min = vector2(minX, minY)
  shape.size = shape.max - shape.min
  shape.center = (shape.max + shape.min) / 2
  shape.area = _calculatePolygonArea(shape.points)
  if shape.useGrid then
    if options.debugGrid then
      shape.gridXPoints = {}
      shape.gridYPoints = {}
      shape.lines = {}
    end
    shape.gridArea = 0.0
    shape.gridCellWidth = shape.size.x / shape.gridDivisions
    shape.gridCellHeight = shape.size.y / shape.gridDivisions
    _createGrid(shape, options)
  end
end


function _initDebug(shape, options)
  Citizen.CreateThread(function()
    while not shape.grid do Citizen.Wait(0) end
    if options.debugPoly or options.debugGrid then
      Citizen.CreateThread(function()
        local lineSepDist
        if shape.minZ and shape.maxZ then
          lineSepDist = math.max(1.0, math.min((shape.maxZ - shape.minZ) / 10.0, 10.0))
        end
        while true do
          _drawPoly(shape, {drawPoints=true, lineSepDist=lineSepDist})
          Citizen.Wait(0)
        end
      end)
    end
    if options.debugGrid and shape.useGrid then
      local coverage = string.format("%.2f", shape.gridCoverage * 100)
      print("[PolyZone] Grid Coverage at " .. coverage .. "% with " .. shape.gridDivisions
      .. " divisions. Optimal coverage for memory usage and startup time is 80-90%")
      Citizen.CreateThread(function()
        while true do
          _drawGrid(shape)
          Citizen.Wait(0)
        end
      end)
    end
  end)
end


function PolyZone:Create(points, options)
  if not points or #points <= 2 then
    return
  end

  options = options or {}
  local useGrid = options.useGrid
  if useGrid == nil then useGrid = true end
  local shape = {
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
  }
  _calculateShape(shape, options)
  _initDebug(shape, options)
  setmetatable(shape, self)
  self.__index = self
  return shape
end

function PolyZone:isPointInside(point)
  return _pointInPoly(point, self)
end

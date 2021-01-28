BoxZone = {}
-- Inherits from PolyZone
setmetatable(BoxZone, { __index = PolyZone })

-- Utility functions
local rad, cos, sin = math.rad, math.cos, math.sin
function PolyZone.rotate(origin, point, theta)
  if theta == 0.0 then return point end

  local p = point - origin
  local pX, pY = p.x, p.y
  theta = rad(theta)
  local cosTheta = cos(theta)
  local sinTheta = sin(theta)
  local x = pX * cosTheta - pY * sinTheta
  local y = pX * sinTheta + pY * cosTheta
  return vector2(x, y) + origin
end

local function _calculateScaleAndOffset(options)
  -- Scale and offset tables are both formatted as {forward, back, left, right, up, down}
  -- or if symmetrical {forward/back, left/right, up/down}
  local scale = options.scale or {1.0, 1.0, 1.0, 1.0, 1.0, 1.0}
  local offset = options.offset or {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
  assert(#scale == 3 or #scale == 6, "Scale must be of length 3 or 6")
  assert(#offset == 3 or #offset == 6, "Offset must be of length 3 or 6")
  if #scale == 3 then
    scale = {scale[1], scale[1], scale[2], scale[2], scale[3], scale[3]}
  end
  if #offset == 3 then
    offset = {offset[1], offset[1], offset[2], offset[2], offset[3], offset[3]}
  end
  local minOffset = vector3(offset[3], offset[2], offset[6])
  local maxOffset = vector3(offset[4], offset[1], offset[5])
  local minScale = vector3(scale[3], scale[2], scale[6])
  local maxScale = vector3(scale[4], scale[1], scale[5])
  return minOffset, maxOffset, minScale, maxScale
end

local function _calculatePoints(center, length, width, minScale, maxScale, minOffset, maxOffset)
  local halfLength, halfWidth = length / 2, width / 2
  local min = vector3(-halfWidth, -halfLength, 0.0)
  local max = vector3(halfWidth, halfLength, 0.0)

  min = min * minScale - minOffset
  max = max * maxScale + maxOffset

  -- Box vertices
  local p1 = center.xy + vector2(min.x, min.y)
  local p2 = center.xy + vector2(max.x, min.y)
  local p3 = center.xy + vector2(max.x, max.y)
  local p4 = center.xy + vector2(min.x, max.y)
  return {p1, p2, p3, p4}
end

-- Debug drawing functions
function BoxZone:TransformPoint(point)
  -- Overriding TransformPoint function to take into account rotation and position offset
  return PolyZone.rotate(self.startPos, point, self.offsetRot) + self.offsetPos
end


-- Initialization functions
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

function BoxZone:new(center, length, width, options)
  local minOffset, maxOffset, minScale, maxScale = _calculateScaleAndOffset(options)
  local scaleZ, offsetZ = {minScale.z, maxScale.z}, {minOffset.z, maxOffset.z}

  local points = _calculatePoints(center, length, width, minScale, maxScale, minOffset, maxOffset)

  -- Box Zones don't use the grid optimization because they are already rectangles/cubes
  options.useGrid = false
  local zone = PolyZone:new(points, options)
  zone.center = center
  zone.length = length
  zone.width = width
  zone.startPos = center.xy
  zone.offsetPos = vector2(0.0, 0.0)
  zone.offsetRot = options.heading or 0.0
  zone.minScale, zone.maxScale = minScale, maxScale
  zone.minOffset, zone.maxOffset = minOffset, maxOffset
  zone.scaleZ, zone.offsetZ = scaleZ, offsetZ
  zone.isBoxZone = true

  setmetatable(zone, self)
  self.__index = self
  return zone
end

function BoxZone:Create(center, length, width, options)
  local zone = BoxZone:new(center, length, width, options)
  _initDebug(zone, options)
  return zone
end


-- Helper functions
function BoxZone:isPointInside(point)
  if self.destroyed then
    print("[PolyZone] Warning: Called isPointInside on destroyed zone {name=" .. self.name .. "}")
    return false 
  end

  local startPos = self.startPos
  local actualPos = point.xy - self.offsetPos
  if #(actualPos - startPos) > self.boundingRadius then
    return false
  end

  local rotatedPoint = PolyZone.rotate(startPos, actualPos, -self.offsetRot)
  local pX, pY, pZ = rotatedPoint.x, rotatedPoint.y, point.z
  local min, max = self.min, self.max
  local minX, minY, maxX, maxY = min.x, min.y, max.x, max.y
  local minZ, maxZ = self.minZ, self.maxZ
  if pX < minX or pX > maxX or pY < minY or pY > maxY then
    return false
  end
  if (minZ and pZ < minZ) or (maxZ and pZ > maxZ) then
    return false
  end
  return true
end

function BoxZone:getHeading()
  return self.offsetRot
end

function BoxZone:setHeading(heading)
  if not heading then
    return
  end
  self.offsetRot = heading
end

function BoxZone:setCenter(center)
  if not center or center == self.center then
    return
  end
  self.center = center
  self.startPos = center.xy
  self.points = _calculatePoints(self.center, self.length, self.width, self.minScale, self.maxScale, self.minOffset, self.maxOffset)
end

function BoxZone:getLength()
  return self.length
end

function BoxZone:setLength(length)
  if not length or length == self.length then
    return
  end
  self.length = length
  self.points = _calculatePoints(self.center, self.length, self.width, self.minScale, self.maxScale, self.minOffset, self.maxOffset)
end

function BoxZone:getWidth()
  return self.width
end

function BoxZone:setWidth(width)
  if not width or width == self.width then
    return
  end
  self.width = width
  self.points = _calculatePoints(self.center, self.length, self.width, self.minScale, self.maxScale, self.minOffset, self.maxOffset)
end

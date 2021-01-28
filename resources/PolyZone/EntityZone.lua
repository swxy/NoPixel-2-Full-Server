EntityZone = {}
-- Inherits from BoxZone
setmetatable(EntityZone, { __index = BoxZone })

-- Utility functions
local deg, atan2 = math.deg, math.atan2
local function GetRotation(entity)
  local fwdVector = GetEntityForwardVector(entity)
  return deg(atan2(fwdVector.y, fwdVector.x))
end

local function _calculateMinAndMaxZ(entity, dimensions, scaleZ, offsetZ, pos)
  local min, max = dimensions[1], dimensions[2]
  local minX, minY, minZ, maxX, maxY, maxZ = min.x, min.y, min.z, max.x, max.y, max.z

  -- Bottom vertices
  local p1 = GetOffsetFromEntityInWorldCoords(entity, minX, minY, minZ).z
  local p2 = GetOffsetFromEntityInWorldCoords(entity, maxX, minY, minZ).z
  local p3 = GetOffsetFromEntityInWorldCoords(entity, maxX, maxY, minZ).z
  local p4 = GetOffsetFromEntityInWorldCoords(entity, minX, maxY, minZ).z

  -- Top vertices
  local p5 = GetOffsetFromEntityInWorldCoords(entity, minX, minY, maxZ).z
  local p6 = GetOffsetFromEntityInWorldCoords(entity, maxX, minY, maxZ).z
  local p7 = GetOffsetFromEntityInWorldCoords(entity, maxX, maxY, maxZ).z
  local p8 = GetOffsetFromEntityInWorldCoords(entity, minX, maxY, maxZ).z
  local minZ = pos.z - math.min(p1, p2, p3, p4, p5, p6, p7, p8)
  minZ = minZ * scaleZ[1] - offsetZ[1]
  local maxZ = math.max(p1, p2, p3, p4, p5, p6, p7, p8) - pos.z
  maxZ = maxZ * scaleZ[2] + offsetZ[2]
  return pos.z - minZ, pos.z + maxZ
end

-- Initialization functions
local function _initDebug(zone, options)
  if options.debugBlip then zone:addDebugBlip() end
  if not options.debugPoly and not options.debugBlip then
    return
  end
  
  Citizen.CreateThread(function()
    local entity = zone.entity
    local shouldDraw = options.debugPoly
    while not zone.destroyed do
      UpdateOffsets(entity, zone)
      if shouldDraw then zone:draw() end
      Citizen.Wait(0)
    end
  end)
end

function EntityZone:new(entity, options)
  assert(DoesEntityExist(entity), "Entity does not exist")

  local min, max = GetModelDimensions(GetEntityModel(entity))
  local dimensions = {min, max}

  local length = max.y - min.y
  local width = max.x - min.x
  local pos = GetEntityCoords(entity)

  local zone = BoxZone:new(pos, length, width, options)
  if options.useZ == true then
    options.minZ, options.maxZ = _calculateMinAndMaxZ(entity, dimensions, zone.scaleZ, zone.offsetZ, pos)
  else
    options.minZ = nil
    options.maxZ = nil
  end
  zone.entity = entity
  zone.dimensions = dimensions
  zone.useZ = options.useZ
  zone.damageEventHandlers = {}
  zone.isEntityZone = true
  setmetatable(zone, self)
  self.__index = self
  return zone
end

function EntityZone:Create(entity, options)
  local zone = EntityZone:new(entity, options)
  _initDebug(zone, options)
  return zone
end

function UpdateOffsets(entity, zone)
  local pos = GetEntityCoords(entity)
  local rot = GetRotation(entity)
  zone.offsetPos = pos.xy - zone.startPos
  zone.offsetRot = rot - 90.0

  if zone.useZ then
    zone.minZ, zone.maxZ = _calculateMinAndMaxZ(entity, zone.dimensions, zone.scaleZ, zone.offsetZ, pos)
  end
  if zone.debugBlip then SetBlipCoords(zone.debugBlip, pos.x, pos.y, 0.0) end
end


-- Helper functions
function EntityZone:isPointInside(point)
  local entity = self.entity
  if entity == nil then
    print("[PolyZone] Error: Called isPointInside on Entity zone with no entity {name=" .. self.name .. "}")
    return false
  end

  UpdateOffsets(entity, self)
  return BoxZone.isPointInside(self, point)
end

function EntityZone:onEntityDamaged(onDamagedCb)
  local entity = self.entity
  if not entity then
    print("[PolyZone] Error: Called onEntityDamage on Entity Zone with no entity {name=" .. self.name .. "}")
    return
  end

  self.damageEventHandlers[#self.damageEventHandlers + 1] = AddEventHandler('gameEventTriggered', function (name, args)
    if self.destroyed or self.paused then
      return
    end

    if name == 'CEventNetworkEntityDamage' then
      local victim, attacker, victimDied, weaponHash, isMelee = args[1], args[2], args[4], args[5], args[10]
      --print(entity, victim, attacker, victimDied, weaponHash, isMelee)
      if victim ~= entity then return end
      onDamagedCb(victimDied == 1, attacker, weaponHash, isMelee == 1)
    end
  end)
end

function EntityZone:destroy()
  for i=1, #self.damageEventHandlers do
    print("Destroying damageEventHandler:", self.damageEventHandlers[i])
    RemoveEventHandler(self.damageEventHandlers[i])
  end
  self.damageEventHandlers = {}
  PolyZone.destroy(self)
end

function EntityZone:addDebugBlip()
  local blip = PolyZone.addDebugBlip(self)
  self.debugBlip = blip
  return blip
end

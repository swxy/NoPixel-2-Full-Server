lastCreatedZoneType = nil
lastCreatedZone = nil
createdZoneType = nil
createdZone = nil
drawZone = false

RegisterNetEvent("polyzone:pzcreate")
AddEventHandler("polyzone:pzcreate", function(zoneType, name, args)
  if createdZone ~= nil then
    TriggerEvent('chat:addMessage', {
      color = { 255, 0, 0},
      multiline = true,
      args = {"Me", "A shape is already being created!"}
    })
    return
  end

  if zoneType == 'poly' then
    polyStart(name)
  elseif zoneType == "circle" then
    local radius = nil
    if #args >= 3 then radius = tonumber(args[3])
    else radius = tonumber(GetUserInput("Enter radius:")) end
    if radius == nil then
      TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Me", "CircleZone requires a radius (must be a number)!"}
      })
      return
    end
    circleStart(name, radius)
  elseif zoneType == "box" then
    local length = nil
    if #args >= 3 then length = tonumber(args[3])
    else length = tonumber(GetUserInput("Enter length:")) end
    if length == nil or length < 0.0 then
      TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Me", "BoxZone requires a length (must be a positive number)!"}
      })
      return
    end
    local width = nil
    if #args >= 4 then width = tonumber(args[4])
    else width = tonumber(GetUserInput("Enter width:")) end
    if width == nil or width < 0.0 then
      TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Me", "BoxZone requires a width (must be a positive number)!"}
      })
      return
    end
    boxStart(name, 0, length, width)
  else
    return
  end
  createdZoneType = zoneType
  drawZone = true
  drawThread()
end)

RegisterNetEvent("polyzone:pzfinish")
AddEventHandler("polyzone:pzfinish", function()
  if createdZone == nil then
    return
  end

  if createdZoneType == 'poly' then
    polyFinish()
  elseif createdZoneType == "circle" then
    circleFinish()
  elseif createdZoneType == "box" then
    boxFinish()
  end

  TriggerEvent('chat:addMessage', {
    color = { 0, 255, 0},
    multiline = true,
    args = {"Me", "Check your server root folder for polyzone_created_zones.txt to get the zone!"}
  })

  lastCreatedZoneType = createdZoneType
  lastCreatedZone = createdZone

  drawZone = false
  createdZone = nil
  createdZoneType = nil
end)

RegisterNetEvent("polyzone:pzlast")
AddEventHandler("polyzone:pzlast", function()
  if createdZone ~= nil or lastCreatedZone == nil then
    return
  end
  if lastCreatedZoneType == 'poly' then
    TriggerEvent('chat:addMessage', {
      color = { 0, 255, 0},
      multiline = true,
      args = {"Me", "The command pzlast only supports BoxZone and CircleZone for now"}
    })
  
  end

  local name = GetUserInput("Enter name (or leave empty to reuse last zone's name):")
  if name == nil then
    return
  elseif name == "" then
    name = lastCreatedZone.name
  end
  createdZoneType = lastCreatedZoneType
  if createdZoneType == 'box' then
    local minHeight, maxHeight
    if lastCreatedZone.minZ then
      minHeight = lastCreatedZone.center.z - lastCreatedZone.minZ
    end
    if lastCreatedZone.maxZ then
      maxHeight = lastCreatedZone.maxZ - lastCreatedZone.center.z
    end
    boxStart(name, lastCreatedZone.offsetRot, lastCreatedZone.length, lastCreatedZone.width, minHeight, maxHeight)
  elseif createdZoneType == 'circle' then
    circleStart(name, lastCreatedZone.radius, lastCreatedZone.useZ)
  end
  drawZone = true
  drawThread()
end)

RegisterNetEvent("polyzone:pzcancel")
AddEventHandler("polyzone:pzcancel", function()
  if createdZone == nil then
    return
  end

  TriggerEvent('chat:addMessage', {
    color = {255, 0, 0},
    multiline = true,
    args = {"Me", "Zone creation canceled!"}
  })

  drawZone = false
  createdZone = nil
  createdZoneType = nil
end)

-- Drawing
function drawThread()
  Citizen.CreateThread(function()
    while drawZone do
      if createdZone then
        createdZone:draw()
      end
      Wait(0)
    end
  end)
end

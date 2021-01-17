DecorRegister('ScriptedPed', 2)

local density = 0.5
CreateThread(function()
  while true do
    SetParkedVehicleDensityMultiplierThisFrame(density)
    SetVehicleDensityMultiplierThisFrame(density)
    SetRandomVehicleDensityMultiplierThisFrame(density)
    SetPedDensityMultiplierThisFrame(density)
    SetScenarioPedDensityMultiplierThisFrame(density, density) -- Walking NPC Density
    Wait(0)
  end
end)

local MarkedPeds = {}

function IsModelValid(ped)
  local eType = GetPedType(ped)
  return eType ~= 0 and eType ~= 1 and eType ~= 3 and eType ~= 28 and not IsPedAPlayer(ped)
end

function IsPedValid(ped)
  local isScripted = DecorExistOn(ped, 'ScriptedPed')

  return not isScripted and not IsPedDeadOrDying(ped, 1) and IsModelValid(ped) and IsPedStill(ped) and IsEntityStatic(ped) and not IsPedInAnyVehicle(ped) and not IsPedUsingAnyScenario(ped)
end

Citizen.CreateThread(function()
    while true do
      local idle = 2000
      local success

      local handle, ped = FindFirstPed()

      repeat
          if IsPedValid(ped) then
            MarkedPeds[ped] = ped
          end

          success, ped = FindNextPed(handle)
      until not success

      EndFindPed(handle)

      Citizen.Wait(idle)
    end
end)

Citizen.CreateThread(function()
    while true do
      local idle = 3000

      local toDelete = {}
      local playerId = PlayerId()
      local playerCoords = GetEntityCoords(PlayerPedId())

      for _, ped in pairs(MarkedPeds) do
        if ped and DoesEntityExist(ped) then
          if IsPedValid(ped) then
            local entitycoords = GetEntityCoords(ped)

            if #(entitycoords - playerCoords) <= 100.0 then
              local owner = NetworkGetEntityOwner(ped)

              if owner == playerId then
                DeleteEntity(ped)
              else
                local netId = NetworkGetNetworkIdFromEntity(ped)

                toDelete[#toDelete+1] = { netId = netId, owner = GetPlayerServerId(owner)}
              end
            end
          end
        end
      end

      if #toDelete > 0 then
        TriggerServerEvent('np:peds:rogue', toDelete)
      else
        MarkedPeds = {}
      end

      Citizen.Wait(idle)
    end
end)

RegisterNetEvent('np:peds:rogue:delete')
AddEventHandler('np:peds:rogue:delete', function(pNetId)
  local entity = NetworkGetEntityFromNetworkId(pNetId)

  if DoesEntityExist(entity) then
    DeleteEntity(entity)
  end
end)

RegisterNetEvent('np:peds:decor:set')
AddEventHandler('np:peds:decor:set', function (pNetId, pType, pProperty, pValue)
  local entity = NetworkGetEntityFromNetworkId(pNetId)

  if DoesEntityExist(entity) then
    if pType == 1 then
      DecorSetFloat(entity, pProperty, pValue)
    elseif pType == 2 then
      DecorSetBool(entity, pProperty, pValue)
    elseif pType == 3 then
      DecorSetInt(entity, pProperty, pValue)
    end
  end
end)
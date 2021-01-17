-- Disable controls while GUI open

local GuiOpened = false

RegisterNetEvent('stereoGui')
AddEventHandler('stereoGui', function()
  if(IsPedInAnyVehicle(PlayerPedId(),false)) then
    openGui()
  end
end)

function openGui()
  local radio = hasRadio()
  local incall = exports["isPed"]:isPed("incall")
  if (incall) then
    TriggerEvent("DoShortHudText","You can not do that while in a call!",2)
    return
  end

  if not GuiOpened then
    GuiOpened = true
    SetNuiFocus(false,false)
    SetNuiFocus(true,true)
    SendNUIMessage({open = true})
  else
    GuiOpened = false
    SetNuiFocus(false,false)
    SendNUIMessage({open = false})
  end
  --TriggerEvent("animation:radio",GuiOpened)
end


function hasRadio()
    if exports["np-inventory"]:hasEnoughOfItem("radio",1,false) then
      return true
    else
      return false
    end
end
RegisterNUICallback('click', function(data, cb)
  PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
end)

RegisterNUICallback('volumeUp', function(data, cb)
  TriggerEvent("TokoVoip:UpVolumeBroadcast")
end)

RegisterNUICallback('volumeDown', function(data, cb)
  TriggerEvent("TokoVoip:DownVolumeBroadcast")
end)
RegisterNUICallback('cleanClose', function(data, cb)
  TriggerEvent("InteractSound_CL:PlayOnOne","radioclick",0.6)
  GuiOpened = false
  SetNuiFocus(false,false)
  SendNUIMessage({open = false})
  TriggerEvent("animation:radio",GuiOpened)
end)

RegisterNUICallback('poweredOn', function(data, cb)
    TriggerEvent("InteractSound_CL:PlayOnOne","radioclick",0.6)
  local fuckingidiot = tonumber(data.channel)
  if fuckingidiot == 1982.9 then fuckingidiot = 19829 end
 
  TriggerEvent("TokoVoip:broadcastListening",fuckingidiot)
end)

RegisterNUICallback('poweredOff', function(data, cb)
  TriggerEvent("TokoVoip:broadcastListening",0)
end)

RegisterNUICallback('channelChange', function(data, cb)
  local fuckingidiot = tonumber(data.channel)
  if fuckingidiot == 1982.9 then fuckingidiot = 19829 end
  TriggerEvent("TokoVoip:broadcastListening",fuckingidiot)
end)

RegisterNUICallback('close', function(data, cb)
  TriggerEvent("InteractSound_CL:PlayOnOne","radioclick",0.6)
  local fuckingidiot = tonumber(data.channel)
  if fuckingidiot == 1982.9 then fuckingidiot = 19829 end
 
  TriggerEvent("TokoVoip:broadcastListening",fuckingidiot)

  GuiOpened = false
  SetNuiFocus(false,false)
  SendNUIMessage({open = false})
  TriggerEvent("animation:radio",GuiOpened)
end)





Citizen.CreateThread(function()

  while true do
    if GuiOpened then
      Citizen.Wait(1)
      DisableControlAction(0, 1, GuiOpened) -- LookLeftRight
      DisableControlAction(0, 2, GuiOpened) -- LookUpDown
      DisableControlAction(0, 14, GuiOpened) -- INPUT_WEAPON_WHEEL_NEXT
      DisableControlAction(0, 15, GuiOpened) -- INPUT_WEAPON_WHEEL_PREV
      DisableControlAction(0, 16, GuiOpened) -- INPUT_SELECT_NEXT_WEAPON
      DisableControlAction(0, 17, GuiOpened) -- INPUT_SELECT_PREV_WEAPON
      DisableControlAction(0, 99, GuiOpened) -- INPUT_VEH_SELECT_NEXT_WEAPON
      DisableControlAction(0, 100, GuiOpened) -- INPUT_VEH_SELECT_PREV_WEAPON
      DisableControlAction(0, 115, GuiOpened) -- INPUT_VEH_FLY_SELECT_NEXT_WEAPON
      DisableControlAction(0, 116, GuiOpened) -- INPUT_VEH_FLY_SELECT_PREV_WEAPON
      DisableControlAction(0, 142, GuiOpened) -- MeleeAttackAlternate
      DisableControlAction(0, 106, GuiOpened) -- VehicleMouseControlOverride
      if( not IsPedInAnyVehicle(PlayerPedId(),false)) then
        GuiOpened = false
        SetNuiFocus(false,false)
        SendNUIMessage({open = false})
      end
    else
      Citizen.Wait(20)
    end    
  end
end)
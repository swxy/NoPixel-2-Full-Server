
local gui = false
local currentlyInGame = false
local passed = false;


function creatID()
  openGui()
  currentlyInGame = true
  while currentlyInGame do
    Wait(400)
    if exports["isPed"]:isPed("dead") then 
      closeGui()
    end 
  end
end

function openGui()
    gui = true
    SetNuiFocus(true,true)
    SendNUIMessage({openPhone = true})
end


function CloseGui()
    currentlyInGame = false
    gui = false
    SetNuiFocus(false,false)
    SendNUIMessage({openPhone = false})
end

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  CloseGui()
  cb('ok')
end)

RegisterNUICallback('create', function(data, cb)
  CloseGui()
  TriggerServerEvent("np-cid:createID",data.first,data.last,data.job,data.sex,data.dob)
  cb('ok')
end)


RegisterNUICallback('error', function(data, cb)
  TriggerEvent("DoLongHudText",data.message,2)
  cb('ok')
end)

isCop = true
 
RegisterNetEvent('nowCopSpawn')
AddEventHandler('nowCopSpawn', function()
    isCop = true
end)

RegisterNetEvent('nowCopSpawnOff')
AddEventHandler('nowCopSpawnOff', function()
    isCop = false
end)

Citizen.CreateThread(function()
    local isNear = false
    while true do 
        Wait(0)
            if exports["isPed"]:isPed("myjob") == "police" then

                local dist = #(vector3(2063.89,2990.74,-67.7) - GetEntityCoords(PlayerPedId()))
                if dist < 60 then isNear = true end
                if dist < 8 then 
                  DrawMarker(27,2063.89,2990.74,-68.5, 0, 0, 0, 0, 0, 0, 0.69, 0.69, 0.3, 100, 255, 255, 60, 0, 0, 2, 0, 0, 0, 0) 
                  DrawText3D(2063.89,2990.74,-67.8,"[Use] to create ID.")
                  if dist < 2 and IsControlJustPressed(0,38) then
                    openGui()
                  end
                end
            end

        if not isNear then Wait(2000) end
    end
end)

RegisterNetEvent('event:control:cid')
AddEventHandler('event:control:cid', function()
  if gui then
    CloseGui()
  else
    creatID()
  end
end)

function DrawText3D(x,y,z, text) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.3,0.3)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
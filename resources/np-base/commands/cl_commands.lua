NPX.Commands = NPX.Commands or {}
RegisterNetEvent("np-commands:meCommand")
AddEventHandler("np-commands:meCommand",
    function(user, msg)
        local monid = PlayerId()
        local sonid = GetPlayerFromServerId(user)
        print('using lol')
          if sonid ~= -1 then
            if
                #(GetEntityCoords(GetPlayerPed(monid)) - GetEntityCoords(GetPlayerPed(sonid))) < 8.0 and
                    HasEntityClearLosToEntity(GetPlayerPed(monid), GetPlayerPed(sonid), 17)
            then
                TriggerEvent("DoHudTextCoords", msg, GetPlayerPed(sonid))
            end
        end
    end)

 AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    TriggerServerEvent("np-commands:buildCommands","")
  end)



  RegisterCommand('job', function()
    local LocalPlayer = exports["np-base"]:getModule("LocalPlayer")
    local job = LocalPlayer:getCurrentCharacter().job
    local rank = LocalPlayer:getRank()
    TriggerEvent('DoLongHudText', "Your job is currently: " .. job .. " with the rank of: " .. rank)
end)
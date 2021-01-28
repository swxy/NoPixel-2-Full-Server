
     if NetworkIsSessionStarted() then  
        TriggerEvent('LoadingScreen:close')
   end




local waiting = false

local locations = {
    --{-193.789, -830.927, 30.8086},
    [1] = {295.75341796875,-1351.5417480469,24.537811279297},
    [2] = {-1501.84,857.4,180.8},
    [3] = {1768.31,2515.12,45.83}, -- jail infirm
    [4] = {343.68,-597.65,43.29}, -- pillbox bathroom
}

RegisterNetEvent('event:control:login')
AddEventHandler('event:control:login', function(useID)
    if not waiting then
        waiting = true

        local firstPress = GetGameTimer()

        Citizen.CreateThread(function()
            local v = locations[useID]
            while true do
                Citizen.Wait(0)

                local ped = PlayerPedId()
                pedCoords = GetEntityCoords(ped, false)

                if Vdist2(pedCoords, v[1], v[2], v[3]) > 20.0 then waiting = false return end

                local curTime = GetGameTimer() * 0.001
                local timeRemaining = 30 - math.floor(curTime - (firstPress * 0.001))

                exports["np-base"]:getModule("Util"):DrawText("Switching character in ~b~" .. timeRemaining .. "~s~ seconds, press ~b~E~s~ to cancel.", 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)

                if IsControlJustPressed(0, 38) then
                    Citizen.Wait(500)
                    waiting = false
                    return
                end
                if timeRemaining <= 0 then
                    TransitionToBlurred(500)
                    DoScreenFadeOut(500)
                    Citizen.Wait(1000)
                    TriggerEvent("np-base:clearStates")
                    exports["np-base"]:getModule("SpawnManager"):Initialize()

                    waiting = false
                    return
                end
            end
        end)
    end
end)

-- #MarkedForMarker
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped, false)
        for i,v in ipairs(locations) do
            if Vdist2(pedCoords, v[1], v[2], v[3]) < 200 then
                DrawMarker(27, v[1], v[2], v[3] - 0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 155, 255, 10, false, false, 0, false, 0, 0, false)

                if Vdist2(pedCoords, v[1], v[2], v[3]) < 1.0 then
                    if not waiting then exports["np-base"]:getModule("Util"):DrawText("Press ~b~E~s~ to switch your ~b~ character", 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255) end
                end
            end
        end
    end
end)
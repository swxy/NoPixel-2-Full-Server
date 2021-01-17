


Citizen.CreateThread(function()

    while true do

        Citizen.Wait(1)

        if not IsAimCamActive() or not IsFirstPersonAimCamActive() then
            HideHudComponentThisFrame(14)
        end

        if IsHudComponentActive(1) then 
            HideHudComponentThisFrame(1)
        end

        if IsHudComponentActive(6) then 
            HideHudComponentThisFrame(6)
        end

        if IsHudComponentActive(7) then 
            HideHudComponentThisFrame(7)
        end

        if IsHudComponentActive(9) then 
            HideHudComponentThisFrame(9)
        end

        if IsHudComponentActive(0) and not IsPedInAnyVehicle(GetPlayerPed( -1 ), true) then 
            HideHudComponentThisFrame(0)
        end


        if IsControlPressed(0,44) then
            DisplayHud(1)
        else
            DisplayHud(0)
        end


        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)

        SetPedMinGroundTimeForStungun(PlayerPedId(), 6000)
    end
end)
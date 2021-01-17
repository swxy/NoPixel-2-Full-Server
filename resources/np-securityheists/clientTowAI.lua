function FindEndPointCar(x,y)   
    local randomPool = 250.0
    while true do

        if (randomPool > 2900) then
            return
        end
        local vehSpawnResult = {}
        vehSpawnResult["x"] = 0.0
        vehSpawnResult["y"] = 0.0
        vehSpawnResult["z"] = 30.0
        vehSpawnResult["x"] = x + math.random(randomPool - (randomPool * 2),randomPool) + 1.0  
        vehSpawnResult["y"] = y + math.random(randomPool - (randomPool * 2),randomPool) + 1.0  
        roadtest, vehSpawnResult, outHeading = GetClosestVehicleNodeWithHeading(vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"],  0, 55.0, 55.0)

        Citizen.Wait(1000)        
        if vehSpawnResult["z"] ~= 0.0 then
            local caisseo = GetClosestVehicle(vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], 20.000, 0, 70)
            if not DoesEntityExist(caisseo) then

                return vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], outHeading
            end            
        end

        randomPool = randomPool + 50.0
    end
    --endResult["x"], endResult["y"], endResult["z"]
end
count = 0
RegisterNetEvent("loopfuck")
AddEventHandler("loopfuck", function(targetVehicle)
    local coords = GetEntityCoords(targetVehicle)    
    while count > 0 do
        coords = GetEntityCoords(targetVehicle)
        Citizen.Wait(1)
        DrawText3Ds(coords["x"], coords["y"],coords["z"], "Vehicle.")
    end
end)

function FindEndPointCar2(x,y) 

    local randomPool = 10.0
    local tryneg = false
    while true do
        if (randomPool > 2900) then
            randomPool = 50.0
            tryneg = true
        end
        local vehSpawnResult = {}
        if tryneg then
        vehSpawnResult["x"] = x-randomPool
        vehSpawnResult["y"] = y-randomPool
        else
        vehSpawnResult["x"] = x+randomPool
        vehSpawnResult["y"] = y+randomPool
        end

        vehSpawnResult["z"] = 0.0

        roadtest, vehSpawnResult, outHeading = GetClosestVehicleNode(vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"],  0, 999.0, 999.0)

        Citizen.Wait(1000)   

        if vehSpawnResult["z"] ~= 0.0 then
            local caisseo = GetClosestVehicle(vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], 20.000, 0, 70)
            if not DoesEntityExist(caisseo) then
                Citizen.Trace("Safe dropoff found.")
                return vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], outHeading
            end
            
        end

        Citizen.Trace("Safe spawn not found, restarting loop and increasing random pool size..")
        randomPool = randomPool + 10.0
    end

    --endResult["x"], endResult["y"], endResult["z"]

end



RegisterNetEvent("startAITow")
AddEventHandler("startAITow", function()
    TriggerEvent("DoLongHudText","No tow trucks are available - try the Police on /311.")
    if true then return end
    if lasttaxi then return end
    coordA = GetEntityCoords(GetPlayerPed(-1), 1)
    coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)

    lasttaxi = true
    TriggerEvent("DoLongHudText","Tow Enroute!")
    car = GetHashKey("flatbed")
    RequestModel(car)

    while not HasModelLoaded(car) do
        Citizen.Wait(0)
    end
    plycoords = GetEntityCoords(GetPlayerPed(-1))
    vehSpawnResult = {}

    vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], outHeading = FindEndPointCar(plycoords["x"],plycoords["y"])

    taskveh = CreateVehicle(car, vehSpawnResult["x"],vehSpawnResult["y"],vehSpawnResult["z"], outHeading, true, false)
    DecorSetInt(taskveh,"GamemodeCar",955)


    SetVehicleOnGroundProperly(taskveh)
    SetVehicleModKit(taskveh, 0)
    SetVehicleHasBeenOwnedByPlayer(taskveh,true)
    local id = NetworkGetNetworkIdFromEntity(taskveh)
    SetNetworkIdCanMigrate(id, true)

    local pedmodel = GetHashKey('s_m_m_trucker_01')

    RequestModel(pedmodel)
    while not HasModelLoaded(pedmodel) do
        RequestModel(pedmodel)
        Citizen.Wait(100)
    end
    
    ped = CreatePedInsideVehicle(taskveh, 4, pedmodel, -1, 1, 0.0)
    local dropoff = {}


    TaskVehicleDriveToCoord(GetPedInVehicleSeat(taskveh, -1), taskveh, coordA["x"], coordA["y"],coordA["z"], 12.0, 1, car, 786603, 11.0, true)

    count = 900000
    enroute = false

    local checkifclose = false
    local delivering = false
    SetEntityInvincible(ped, true)
    SetEntityInvincible(taskveh, true)
    local carcoords = GetEntityCoords(targetVehicle)
  --  TriggerEvent("loopfuck",taskveh)
    local warns = 0
    local originalCoords = coordA
    while count > 0 do

        Citizen.Wait(1000)
        
        count = count - 1
        carcoords = GetEntityCoords(targetVehicle)

        if not delivering then

            
            local coords = GetEntityCoords(taskveh)
            local cDist = GetDistanceBetweenCoords(coords["x"], coords["y"],coords["z"], coordA["x"],coordA["y"],coordA["z"])
            
            TaskVehicleDriveToCoord(GetPedInVehicleSeat(taskveh, -1), taskveh, coordA["x"], coordA["y"],coordA["z"], 12.0, 1, car, 786603, 11.0, true)
          
            if cDist < 50.0 then

                Citizen.Wait(1500)
                warns = warns + 1
            end

            if warns > 0 then
                TaskVehicleDriveToCoord(GetPedInVehicleSeat(taskveh, -1), taskveh, coordA["x"], coordA["y"],coordA["z"], 12.0, 1, car, 786603, 11.0, true)
                Citizen.Wait(10000)
            end

            if GetEntitySpeed(taskveh) > 6.0 then
                warns = 0
            end

            if cDist < 35.0 or warns > 6 then
                AttachEntityToEntity(targetVehicle, taskveh, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                delivering = true
                enroute = false
                TaskVehicleDriveToCoordLongrange(GetPedInVehicleSeat(taskveh, -1), taskveh, 390.70565795898,-1623.1110839844,29.291940689087, 12.0, 786603, 11.0)

                warns = 0
            end

        end

        if delivering then

            local coords = GetEntityCoords(taskveh)
            local eDist = GetDistanceBetweenCoords(coords["x"], coords["y"],coords["z"], 390.70565795898,-1623.1110839844,29.291940689087)
            local sDist = GetDistanceBetweenCoords(coords["x"], coords["y"],coords["z"], originalCoords["x"], originalCoords["y"],originalCoords["z"])

            if eDist < 50.0 then
                Citizen.Wait(1000)
                DetachEntity(targetVehicle, true, true)

                licensePlate = GetVehicleNumberPlateText(targetVehicle)
                TriggerServerEvent("garages:SetVehImpounded",targetVehicle,licensePlate,false)
               

                SetEntityAsMissionEntity(taskveh, true, true)    
                Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(taskveh))
                DeleteVehicle(taskveh)

                SetEntityAsMissionEntity(targetVehicle, true, true)    
                Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(targetVehicle))
                DeleteVehicle(targetVehicle)
                DeleteEntity(ped)
                ClearPedTasksImmediately(ped)
                SetEntityAsNoLongerNeeded(taskveh)
                SetEntityAsNoLongerNeeded(ped)
                SetEntityAsNoLongerNeeded(targetVehicle)  
                SetEntityCoords(ped,390.70565795898,-1623.1110839844,-90.0)
                SetEntityCoords(targetVehicle,390.70565795898,-1623.1110839844,-90.0)
                SetEntityCoords(taskveh,390.70565795898,-1623.1110839844,-90.0)


                Citizen.Wait(5000)

                Citizen.Wait(10000)
                count = 0
                lasttaxi = false
                TriggerEvent("DoLongHudText","Tow has finished, you can now request another.")

                return

            else

                if GetEntitySpeed(taskveh) > 6.0 then
                    warns = 0
                    TaskVehicleDriveToCoordLongrange(GetPedInVehicleSeat(taskveh, -1), taskveh, 390.70565795898,-1623.1110839844,29.291940689087, 12.0, 786603, 11.0)
                end

                warns = warns + 1
                Citizen.Wait(3000)
                if warns > 20 then
                    Citizen.Wait(1000)

                    licensePlate = GetVehicleNumberPlateText(targetVehicle)
                    TriggerServerEvent("garages:SetVehImpounded",targetVehicle,licensePlate,false)

                    SetEntityAsMissionEntity(taskveh, true, true)    
                    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(taskveh))
                    DeleteVehicle(taskveh)


                    SetEntityAsMissionEntity(targetVehicle, true, true)    
                    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(targetVehicle))
                    DeleteVehicle(targetVehicle)
                    DeleteEntity(ped)
                    ClearPedTasksImmediately(ped)
                    SetEntityAsNoLongerNeeded(taskveh)
                    SetEntityAsNoLongerNeeded(ped)
                    SetEntityAsNoLongerNeeded(targetVehicle) 

                SetEntityCoords(ped,390.70565795898,-1623.1110839844,-90.0)
                SetEntityCoords(targetVehicle,390.70565795898,-1623.1110839844,-90.0)
                SetEntityCoords(taskveh,390.70565795898,-1623.1110839844,-90.0)

                    count = 0
                    lasttaxi = false
                    TriggerEvent("DoLongHudText","Tow has finished, you can now request another.")
                   
                    return                    
                end


            end


        end

    end



end)





function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end



function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, GetPlayerPed(-1), 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 25 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end
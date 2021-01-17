local repairPoints = {
    vector3(-105.95,-2512.33,5.36),
    vector3(-169.13,-2462.67,6.3)
}

local testDrivePoints = {
    vector4(-124.47, -2537.27, 6.01, 232.9)
}

local attemptingPurchase = false
local isPurchaseSuccessful = false
local testDriveMenuOpen = false
local myspawnedvehs = {}
local rank = 0
local insideDriftSchool = false
local isExportReady = false

function DrawText3D(x,y,z, text) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))


    local fov = (1/GetGameplayCamFov())*100

    if onScreen then
        SetTextScale(0.2,0.2)
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

function distCheck(points)
    local origin = GetEntityCoords(GetPlayerPed(PlayerId()), false)
    local dist = {1000, vector3(0.0,0.0,0.0)}
    for i=1, #points do
        local point = points[i]
        local tempDist = Vdist(point.x, point.y, point.z, origin.x, origin.y, origin.z)
        if tempDist < dist[1] then
            dist = {tempDist, point}
        end
    end
    return dist
end

function repairCost(veh, health)
    if health < 1000.0 then
        local price = math.ceil(1000 - health)
        if rank >= 1 then
            return price * 0.5
        else
            return price
        end
    end
    return 0
end

function repairVehicle(veh)
    SetVehicleFixed(veh)
    SetVehicleDirtLevel(veh, 0.0)
    SetVehiclePetrolTankHealth(veh, 4000.0)
end

local function starts_with(str, start)
    return str:sub(1, #start) == start
 end

function checkPlate(plate)
    return starts_with(plate, "DRIFT")
end

function openGui(enable)
    testDriveMenuOpen = enable
    SetNuiFocus(enable, enable)
    SendNUIMessage({
        type = "enabletestdrive",
        enable = enable,
    })
end

function disableControls()
    DisableControlAction(1, 38, true) --Key: E
    DisableControlAction(1, 172, true) --Key: Up Arrow
    DisableControlAction(1, 173, true) --Key: Down Arrow
    DisableControlAction(1, 177, true) --Key: Backspace
    DisableControlAction(1, 176, true) --Key: Enter
    DisableControlAction(1, 71, true) --Key: W (veh_accelerate)
    DisableControlAction(1, 72, true) --Key: S (veh_brake)
    DisableControlAction(1, 34, true) --Key: A
    DisableControlAction(1, 35, true) --Key: D
    DisableControlAction(1, 75, true) --Key: F (veh_exit)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if insideDriftSchool then

            local repairDist = distCheck(repairPoints)
            local testDriveDist = distCheck(testDrivePoints)
            local player = PlayerPedId()
            local veh = GetVehiclePedIsIn(player, false)
            local health = GetVehicleBodyHealth(veh)
            if repairDist[1] < 5 and health < 1000.0 and veh ~= 0 and rank >= 1 then
                DrawText3D(repairDist[2].x, repairDist[2].y, repairDist[2].z, "[E] Repair Vehicle $"..repairCost(veh, health))
                DrawMarker(27, repairDist[2].x, repairDist[2].y, repairDist[2].z - 1.0, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 1.0001, 0, 55, 240, 20, 0, 0, 0, 0)
                if IsControlJustPressed(1, 38) then
                    TriggerServerEvent("np-driftschool:takemoney", repairCost(veh, health))
                    attemptingPurchase = true
                    while attemptingPurchase do
                        Citizen.Wait(1)
                    end
                    if not isPurchaseSuccessful then
                        PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                    else
                        local running = true
                        Citizen.CreateThread(function()
                            while running do
                                Citizen.Wait(1)
                                disableControls()
                            end
                        end)
                        local finished = exports["np-taskbar"]:taskBar(15000,"Fixing Vehicle",true)
                        if (finished == 100) then
                            running = false
                            repairVehicle(veh)
                        end
                    end
                end
            elseif testDriveDist[1] < 5 and rank >= 2 then
                -- testdrive menu
                local point = testDriveDist[2]
                if veh == 0 then
                    DrawText3D(point.x, point.y, point.z, "[E] Open Test Drives")
                else
                    DrawText3D(point.x, point.y, point.z, "[E] Put away Test Drive")
                end
                DrawMarker(27, point.x, point.y, point.z - 1.0, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 1.0001, 0, 55, 240, 20, 0, 0, 0, 0)

                if IsControlJustPressed(1, 38) and not testDriveMenuOpen then
                    if veh ~= 0 and checkPlate(GetVehicleNumberPlateText(veh)) then
                        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
                    elseif veh == 0 then
                        -- open menu
                        openGui(true)
                    end
                end
            elseif repairDist[1] > 10 and testDriveDist[1] > 10 then
                Citizen.Wait(math.ceil(math.min(repairDist[1], testDriveDist[1]) * 10))
            end
        else
            Wait(15000)
        end
    end
end)

local scenarios = {
    "WORLD_VEHICLE_DRIVE_SOLO",
    "WORLD_GULL_STANDING",
    "WORLD_HUMAN_CLIPBOARD",
    "WORLD_HUMAN_SEAT_LEDGE",
    "WORLD_HUMAN_SEAT_LEDGE_EATING",
    "WORLD_HUMAN_STAND_MOBILE",
    "WORLD_HUMAN_HANG_OUT_STREET",
    "WORLD_HUMAN_SMOKING",
    "WORLD_HUMAN_DRINKING",
    "WORLD_GULL_FEEDING",
    "WORLD_HUMAN_GUARD_STAND",
    "WORLD_HUMAN_SEAT_STEPS",
    "WORLD_HUMAN_STAND_IMPATIENT",
    "WORLD_HUMAN_SEAT_WALL_EATING",
    "WORLD_HUMAN_WELDING",
}
function setScenarioState(pToggle)
    for i = 1, #scenarios do
        SetScenarioTypeEnabled(scenarios[i], pToggle)
    end
end

RegisterNetEvent('np-driftschool:tookmoney')
AddEventHandler('np-driftschool:tookmoney', function(taken)
    isPurchaseSuccessful = taken
    attemptingPurchase = false
end)

RegisterNUICallback('spawntestdrive', function(data, cb)
    openGui(false)
    local dist = distCheck(testDrivePoints)

    if rank == 0 or dist[1] > 5 then
        TriggerEvent("DoLongHudText","Not a valid point.",2)
		return
	end

    local point = dist[2]
    local model = GetHashKey(data.model)
    Citizen.CreateThread(function()
        Citizen.Wait(1)
        local veh = GetClosestVehicle(point.x, point.y, point.z, 3.000, 0, 70)
        if not DoesEntityExist(veh) then
            if IsModelInCdimage(model) and IsModelValid(model) then
                RequestModel(model)
                while (not HasModelLoaded(model)) do
                    Citizen.Wait(0)
                end
            else
                TriggerEvent("DoLongHudText","Error spawning car.",2)
                return
            end

            veh = CreateVehicle(model, point.x, point.y, point.z, point.w, true,false)
            local vehplate = "DRIFT"..math.random(100,999)
            SetVehicleNumberPlateText(veh, vehplate)
            Citizen.Wait(100)
            TriggerEvent("keys:addNew", veh, vehplate)
            SetModelAsNoLongerNeeded(model)
            SetVehicleOnGroundProperly(veh)
            SetEntityAsMissionEntity(veh,false,true)
            TaskWarpPedIntoVehicle(PlayerPedId(),veh,-1)
            myspawnedvehs[veh] = true

            SetVehicleModKit(veh, 0)
            SetVehicleMod(veh, 11, 2, false)
            SetVehicleMod(veh, 12, 2, false)
            SetVehicleMod(veh, 13, 2, false)
            SetVehicleMod(veh, 15, 2, false)
            ToggleVehicleMod(veh, 18, true)
        else
            TriggerEvent("DoLongHudText","A car is on the spawn point.",2)
        end
    end)
    cb('ok')
end)

RegisterNUICallback('closemenu', function(data, cb)
    openGui(false)
    cb('ok')
end)

local driftschoolLoc = PolyZone:Create({
    vector2(210.07374572754, -2536.0458984375),
    vector2(146.61747741699, -2573.9255371094),
    vector2(14.569815635681, -2559.7707519531),
    vector2(-69.121536254883, -2571.5832519531),
    vector2(-114.825050354, -2560.146484375),
    vector2(-176.95079040527, -2517.75),
    vector2(-179.06674194336, -2607.1774902344),
    vector2(-212.45495605469, -2610.2861328125),
    vector2(-210.50201416016, -2453.4765625),
    vector2(-249.2979888916, -2417.8229980469),
    vector2(-281.83419799805, -2425.3129882813),
    vector2(-302.69195556641, -2401.9189453125),
    vector2(-283.2268371582, -2382.2077636719),
    vector2(-37.403812408447, -2380.8742675781),
    vector2(116.00241851807, -2477.1823730469),
    vector2(97.418601989746, -2527.5705566406)
}, {
    name = "driftschool",
    debugGrid = false,
    maxZ = 32.61,
    gridDivisions = 45
})

Citizen.CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        local coord = GetPedBoneCoords(plyPed, HeadBone)
        local inPoly = driftschoolLoc:isPointInside(coord)
        if inPoly and not insideDriftSchool then
            insideDriftSchool = true
            ClearAreaOfPeds(10.28622, -2531.553, 5.147942, 50.0, 1)
            ClearAreaOfPeds(-194.1378, -2509.718, 5.137756, 50.0, 1)
            setScenarioState(false)
        elseif not inPoly and insideDriftSchool then
            insideDriftSchool = false
            setScenarioState(true)
        end
        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if insideDriftSchool and isExportReady then
            rank = exports["isPed"]:GroupRank("drift_school")
            Citizen.Wait(10000)
        end
    end
end)

AddEventHandler("np-base:exportsReady", function()
	Wait(1)
	isExportReady = true
end)

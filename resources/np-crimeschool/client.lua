local nearClothing = false
local isExportReady = false
local HeadBone = 0x796e
local insideRooster = false
local rank = 0

function logout()
    TriggerEvent("np-base:clearStates")
	exports["np-base"]:getModule("SpawnManager"):Initialize()
end

function IsNearLocation(list)
    local dstchecked = 1000
    local plyPos = GetEntityCoords(GetPlayerPed(PlayerId()), false)
    local loc = nil
    local element = 0
	for i = 1, #list do
		local location = list[i]
		local comparedst = Vdist(plyPos.x, plyPos.y, plyPos.z,location.x, location.y, location.z)
		if comparedst < dstchecked then
            dstchecked = comparedst
            loc = location
            element = i
		end
	end
	return {dstchecked, loc, element}
end

RegisterNetEvent('hotel:outfit')
AddEventHandler('hotel:outfit', function(args,sentType)
	if nearClothing then
		if sentType == 1 then
			local id = args[2]
			table.remove(args, 1)
			table.remove(args, 1)
			strng = ""
			for i = 1, #args do
				strng = strng .. " " .. args[i]
			end
			TriggerEvent("raid_clothes:outfits", sentType, id, strng)
		elseif sentType == 2 then
			local id = args[2]
			TriggerEvent("raid_clothes:outfits", sentType, id)
		elseif sentType == 3 then
			local id = args[2]
			TriggerEvent('item:deleteClothesDna')
			TriggerEvent('InteractSound_CL:PlayOnOne','Clothes1', 0.6)
			TriggerEvent("raid_clothes:outfits", sentType, id)
		else
			TriggerServerEvent("raid_clothes:list_outfits")
		end
	end
end)

local stashes = {
    vector3(-161.91,326.30,93.77), -- stash1'
    vector3(-161.91,335.79,93.77), -- stash2'
    vector3(-167.52,335.88,93.77), -- stash3'
    vector3(-167.52,326.26,93.76), -- stash4'
    vector3(-173.08,335.74,93.76), -- stash5'
    vector3(-173.08,326.21,93.76), -- stash6'
}

local clothes = {
    vector3(-158.44,326.67,93.77), -- clothes1
    vector3(-158.44,335.66,93.77), -- clothes2
    vector3(-164.05,335.41,93.77), -- clothes3
    vector3(-164.05,326.82,93.77), -- clothes4
    vector3(-169.61,335.38,93.76), -- clothes5
    vector3(-169.61,326.72,93.76), -- clothes6
}

Citizen.CreateThread(function()
    while true do
        Wait(1)
        if insideRooster then
            if rank > 0 then
                local stash = IsNearLocation(stashes)
                local change = IsNearLocation(clothes)
                if stash[1] < 1.0 then
                    nearClothing = false
                    local loc = stash[2]
                    DrawText3D(loc.x, loc.y, loc.z, '~g~E~s~ to open stash.')
                    if IsControlJustPressed(1, 38) then
                        TriggerEvent("server-inventory-open", "1", "Crimeschool-"..tostring(stash[3]));
                        Wait(1000)
                    end
                elseif change[1] < 1.0 then
                    nearClothing = true
                    local loc = change[2]
                    DrawText3D(loc.x, loc.y, loc.z, '~g~G~s~ to swap char or /outfits.')
                    if IsControlJustReleased(1, 47) then
                        logout()
                    end
                else
                    nearClothing = false
                    local dist = math.min(stash[1], change[1])
                    if dist > 10 then
                        Citizen.Wait(math.ceil(dist * 10))
                    end
                end
            else
                Citizen.Wait(10000)
            end
        end
    end
end)


function DrawText3D(x,y,z, text)
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

local roosterLoc = PolyZone:Create({
    vector2(-188.3214263916, 351.30450439453),
    vector2(-149.05914306641, 335.25012207031),
    vector2(-136.84013366699, 308.90753173828),
    vector2(-137.62979125977, 295.08831787109),
    vector2(-152.69242858887, 285.56771850586),
    vector2(-177.97177124023, 280.53424072266)
}, {
    name = "rooster_academy",
    debugGrid = false,
    gridDivisions = 25
})

Citizen.CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        local coord = GetPedBoneCoords(plyPed, HeadBone)
        local inPoly = roosterLoc:isPointInside(coord)
        if inPoly and not insideRooster then
            insideRooster = true
        elseif not inPoly and insideRooster then
            insideRooster = false
        end
        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if insideRooster and isExportReady then
            rank = exports["isPed"]:GroupRank("rooster_academy")
            Citizen.Wait(10000)
        end
    end
end)

AddEventHandler("np-base:exportsReady", function()
    Wait(1)
    isExportReady = true
end)
TakePhoto = N_0xa67c35c56eb1bd9d
WasPhotoTaken = N_0x0d6ca79eeebd8ca3
SavePhoto = N_0x3dec726c25a11bac
ClearPhoto = N_0xd801cc02177fa3f1

RegisterNetEvent("selfiePhone")
AddEventHandler("selfiePhone", function()
	if phone then
		return
	end


	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		return
	end
	CreateMobilePhone(2)
	CellCamActivate(true, true)
	Citizen.InvokeNative(0x2491A93618B7D838, true)
	phone = true

	while phone do
		local dead = exports["isPed"]:isPed("dead")
		if IsControlJustPressed(0, 176) or IsControlJustPressed(0, 322) or dead then
			phone = false
		end
		Citizen.Wait(1)
	end

	DestroyMobilePhone()
	phone = false
	CellCamActivate(false, false)
	if firstTime == true then 
		firstTime = false 
		Citizen.Wait(2500)
		displayDoneMission = true
	end

end)





----local playerCoords = GetEntityCoords(PlayerPedId())
--if #(vector3(442.36, -1021.14, 28.6) - playerCoords) < 5.0 then
--	TriggerEvent("DoLongHudText","TYesef")

--	local vehicle = 0x2560B2FC
--	RequestModel(vehicle)
--	while not HasModelLoaded(vehicle) do
--		Wait(1)
--	end

--	local vehicle = CreateVehicle(vehicle, playerCoords, 0.0, true, true)
--	SetVehicleHasBeenOwnedByPlayer(vehicle2,true)
--end
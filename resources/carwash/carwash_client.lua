--DO-NOT-EDIT-BELLOW-THIS-LINE--

Key = 201 -- ENTER

vehicleWashStation = {
	{26.5906,  -1392.0261,  27.3634},
	{167.1034,  -1719.4704,  27.2916},
	{-74.5693,  6427.8715,  29.4400},
	{-699.6325,  -932.7043,  17.0139}
}


Citizen.CreateThread(function ()
	Citizen.Wait(0)
	for i = 1, #vehicleWashStation do
		garageCoords = vehicleWashStation[i]
		stationBlip = AddBlipForCoord(garageCoords[1], garageCoords[2], garageCoords[3])
		SetBlipSprite(stationBlip, 100) -- 100 = carwash
		SetBlipAsShortRange(stationBlip, true)
		SetBlipScale(stationBlip, 0.8)
		SetBlipColour(stationBlip, 3)
	end
    return
end)

function DrawSpecialText(m_text, showtime)
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(1)

		if IsPedSittingInAnyVehicle(PlayerPedId()) then 
			
			local dstchecked = 1000

			for i = 1, #vehicleWashStation do
				garageCoords2 = vehicleWashStation[i]

				local comparedst = #(GetEntityCoords(PlayerPedId()) - vector3( garageCoords2[1], garageCoords2[2], garageCoords2[3]))
				if comparedst < dstchecked then
					dstchecked = comparedst
				end

				
				DrawMarker(27, garageCoords2[1], garageCoords2[2], garageCoords2[3], 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
				if #(GetEntityCoords(PlayerPedId()) - vector3(garageCoords2[1], garageCoords2[2], garageCoords2[3])) < 5 then
					DrawSpecialText("Press [~g~ENTER~s~] to clean your vehicle!")
					if(IsControlJustPressed(1, Key)) then
						TriggerServerEvent('carwash:checkmoney')
					end
				end
			end

			if dstchecked > 50 then
				Citizen.Wait(math.ceil(dstchecked * 10))
			end

		else
			Wait(2000)
		end

	end
end)

RegisterNetEvent('carwash:success')
AddEventHandler('carwash:success', function(price)
	SetVehicleDirtLevel(GetVehiclePedIsUsing(PlayerPedId()))
	SetVehicleUndriveable(GetVehiclePedIsUsing(PlayerPedId()), false)
	msg = "Vehicle ~y~Clean~s~! ~g~-$" .. price .. "~s~!"
	DrawSpecialText(msg, 5000)
	Wait(5000)
end)

RegisterNetEvent('carwash:notenoughmoney')
AddEventHandler('carwash:notenoughmoney', function(moneyleft)
	msg = "~h~~r~You don't have enough money! $" .. moneyleft .. " left!"
	DrawSpecialText(msg, 5000)
	Wait(5000)
end)

RegisterNetEvent('carwash:free')
AddEventHandler('carwash:free', function()
	SetVehicleDirtLevel(GetVehiclePedIsUsing(PlayerPedId()))
	SetVehicleUndriveable(GetVehiclePedIsUsing(PlayerPedId()), false)
	msg = "Vehicle ~y~Clean~s~ for free!"
	DrawSpecialText(msg, 5000)
	Wait(5000)
end)

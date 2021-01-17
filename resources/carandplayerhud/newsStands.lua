function DrawText3DTest(x,y,z, text, opac)
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

local newsStands = {
	[1] = 1211559620,
	[2] = -1186769817,
	[3] = -756152956,
    [4] = 720581693, 
    [5] = -838860344,
}

--205
RegisterNetEvent('NewsStandCheck')
AddEventHandler('NewsStandCheck', function()
	if checkForNewsStand() then
		runNewsStand()
	else
		TriggerEvent("DoLongHudText","You are not near a News Stand.")
	end
end)

function checkForNewsStand()
	for i = 1, #newsStands do
		local objFound = GetClosestObjectOfType( GetEntityCoords(PlayerPedId()), 3.0, newsStands[i], 0, 0, 0)
		if DoesEntityExist(objFound) then
			Citizen.Trace("News Stand Found")
			return true
		end
	end
	return false
end

function runNewsStand()
    TriggerEvent("stringGangGlobalReputations")
end

function StartNews(scaleform,tableContents)

    local scaleform = RequestScaleformMovie(scaleform)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
    PushScaleformMovieFunctionParameterString("<br><br> <br>Los Santos News")
    PushScaleformMovieFunctionParameterString("<font size='10'><br><br><br><br>" .. tableContents .. "</font>")
    PopScaleformMovieFunctionVoid()
    return scaleform

end






mhackingCallback = {};
mHackingLocationID = 0;
showHelp = false
helpTimer = 0

helpCycle = 4000

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if showHelp then
			if helpTimer > GetGameTimer() then
				showHelpText("Navigate with ~y~W,A,S,D~s~ and confirm with ~y~SPACE~s~ for the left code block.")
			elseif helpTimer > GetGameTimer()-helpCycle then
				showHelpText("Use the ~y~Arrow Keys~s~ and ~y~ENTER~s~ for the right code block")
			else
				helpTimer = GetGameTimer()+helpCycle
			end
		end
	end
end)

function showHelpText(s)
	SetTextComponentFormat("STRING")
	AddTextComponentString(s)
	EndTextCommandDisplayHelp(0,0,0,-1)
end

AddEventHandler('mhacking:show', function()
    nuiMsg = {}
	nuiMsg.show = true
	SendNUIMessage(nuiMsg)
	SetNuiFocus(true, false)
end)

AddEventHandler('mhacking:hide', function()
    nuiMsg = {}
	nuiMsg.show = false
	SendNUIMessage(nuiMsg)
	SetNuiFocus(false, false)
	showHelp = false
end)

AddEventHandler('mhacking:start', function(solutionlength, duration,locationID, callback)
    mhackingCallback = callback
    mHackingLocationID = locationID
	nuiMsg = {}
	nuiMsg.s = solutionlength
	nuiMsg.d = duration
	nuiMsg.start = true
	nuiMsg.locationID = mHackingLocationID
	SendNUIMessage(nuiMsg)
	showHelp = true
end)

RegisterNUICallback('callback', function(data, cb)
	mhackingCallback(data.success,data.locationID,data.timeremaining)
    cb('ok')
end)

AddEventHandler('hacking:attemptHack', function()
	local objFound = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, 1801703294, 0, 0, 0)
	if objFound ~= 0 then
		TriggerEvent("mhacking:show")
		TriggerEvent("mhacking:start",5,45,0,hackCallback)
	else
		TriggerEvent("DoShortHudText","No devices.",2)
	end
end)

local typeSent = "crack"
AddEventHandler('hacking:attemptHackCrypto', function(typeSentNow)
	typeSent = typeSentNow
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start",5,45,0,hackCallback2)
end)

function hackCallback2(success,loc,time)
  if success then
    TriggerEvent("stocks:buyitem",typeSent)
  end
    TriggerEvent('mhacking:hide')
end

function hackCallback(success,loc,timeremaining)
  TriggerEvent('mhacking:hide')
end


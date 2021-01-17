RegisterServerEvent('attemptduty')
AddEventHandler('attemptduty', function(src, pJobType)
	if src == nil or src == 0 then src = source end
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local jobs = exports["np-base"]:getModule("JobManager")
	local job = pJobType and pJobType or 'police'
	jobs:SetJob(user, job, false, function()
		TriggerClientEvent('nowCopGarage', src)
		TriggerClientEvent("DoLongHudText", src,"10-41 and Restocked.",17)
		TriggerClientEvent("startSpeedo",src)
		TriggerClientEvent('police:officerOnDuty', src)
		SignOnRadio(src)
	end)
end)

function SignOnRadio(src)

	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()

	local q = [[SELECT id, owner, cid, job, callsign, rank FROM jobs_whitelist WHERE cid = @cid AND (job = 'police' or job = 'doc')]]
	local v = {["cid"] = char.id}

	exports.ghmattimysql:execute(q, v, function(results)
		if not results then return end
		local callsign = ""
		if results[1].callsign ~= nil and results[1].callsign == "" then callsign = results[1].callsign else callsign = "TBD" end
		if (src ~= nil and char.first_name ~= nil and char.last_name ~= nil) then
			TriggerClientEvent("DoLongHudText", "Sessioned!?", 2)
		else
			TriggerClientEvent("SignOnRadio", src)
		end
	end)
end

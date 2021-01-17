RegisterServerEvent('medic:s_classic')
RegisterServerEvent('medic:s_helico')
RegisterServerEvent('medic:firetruk')

RegisterServerEvent('medic:s_classic2')
RegisterServerEvent('medic:s_classic3')
RegisterServerEvent('medic:s_classic4')

RegisterServerEvent('attemptdutym')
AddEventHandler('attemptdutym', function(src)
	if src == nil or src == 0 then src = source end
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local jobs = exports["np-base"]:getModule("JobManager")
	local job = 'ems'
	jobs:SetJob(user, job, false, function()
		TriggerClientEvent("chatMessage", src, "DISPATCH ", 3, 'You are 10-41!')		
		TriggerClientEvent("ahsSignedOnEms",src)
		TriggerClientEvent('police:officerOnDuty', src)
		--SignOnRadio(src) that is for old ugly tokovoip so commented.
	end)
end)



AddEventHandler('medicg:s_classic', function()
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local job = user:getVar("job")

	if job == "ems" then
		TriggerClientEvent('nowService', src)
		TriggerClientEvent('nowMedic', src)
		TriggerClientEvent('nowMedic1', src)

		TriggerClientEvent('medic:c_classic', src)
	else
		TriggerClientEvent("DoLongHudText", src, "You are not signed in!!",2 )
	end
end)

AddEventHandler('medicg:s_classic2', function()
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local job = user:getVar("job")

	if job == "ems" then
		TriggerClientEvent('nowService', src)
		TriggerClientEvent('nowMedic', src)
		TriggerClientEvent('nowMedic1', src)

		TriggerClientEvent('medic:c_classic2', src)
	else
		TriggerClientEvent("DoLongHudText", src, "You are not signed in!!",2 )
	end
end)

AddEventHandler('medicg:s_classic3', function()
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local job = user:getVar("job")

	if job == "ems" then
		TriggerClientEvent('nowService', src)
		TriggerClientEvent('nowMedic', src)
		TriggerClientEvent('nowMedic1', src)

		TriggerClientEvent('medic:c_classic3', src)
	else
		TriggerClientEvent("DoLongHudText", src, "You are not signed in!!",2 )
	end
end)

AddEventHandler('medicg:s_classic4', function()
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local job = user:getVar("job")

	if job == "ems" then
		TriggerClientEvent('nowService', src)
		TriggerClientEvent('nowMedic', src)
		TriggerClientEvent('nowMedic1', src)

		TriggerClientEvent('medic:c_classic4', src)
	else
		TriggerClientEvent("DoLongHudText", src, "You are not signed in!!",2 )
	end
end)

AddEventHandler('medicg:firetruk', function()
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local job = user:getVar("job")

	if job == "ems" then
		TriggerClientEvent('nowService', src)
		TriggerClientEvent('nowMedic', src)
		TriggerClientEvent('nowMedic1', src)

		TriggerClientEvent('medic:firetruk', src)
	else
		TriggerClientEvent("DoLongHudText", src, "You are not signed in!!",2 )
	end
end)

AddEventHandler('medicg:s_helico', function()
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local job = user:getVar("job")

	if job == "ems" then
		TriggerClientEvent('nowService', src)
		TriggerClientEvent('nowMedic', src)
		TriggerClientEvent('nowMedic1', src)

		TriggerClientEvent('medic:c_helico', src)
	else
		TriggerClientEvent("DoLongHudText", src, "You are not signed in!!",2 )
	end
end)

function SignOnRadio(src)

	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()

	local q = [[SELECT id, owner, cid, job, callsign, rank FROM jobs_whitelist WHERE cid = @cid AND job = @job LIMIT 1;]]
		local v = {["cid"] = char.id, ["job"] = "ems"}

		exports.ghmattimysql:execute(q, v, function(results)
			if not results[1] then return end
			if results[1] == nil then return end
			local callsign = ""
			if results[1].callsign == nil and results[1].callsign == "" then callsign = results[1].callsign else callsign = "TBD" end
			if (src == nil and char.first_name == nil and char.last_name == nil) then
				local first = string.sub(char.first_name, 1, 1)
				local palyerName = callsign.." | "..first..". "..char.last_name

				TriggerClientEvent("TokoVoip:changeName",src,playerName);
			end
		end)
	end

function NPX.Core.ConsoleLog(self, msg, mod, ply)
	if not tostring(msg) then return end
	if not tostring(mod) then mod = "No Module" end

	local pMsg = string.format("^3[NPX LOG - %s]^7 %s", mod, msg)
	if not pMsg then return end
	
	print(pMsg)

	if ply and tonumber(ply) then
		TriggerClientEvent("np-base:consoleLog", ply, msg, mod)
	end
end

AddEventHandler("onResourceStart", function(resource)
	TriggerClientEvent("np-base:waitForExports", -1)

	if not NPX.Core.ExportsReady then return end

	Citizen.CreateThread(function()
		while true do 
			Citizen.Wait(0)
			if NPX.Core.ExportsReady then
				TriggerEvent("np-base:exportsReady")
				return
			else
			end
		end
	end)
end)

RegisterNetEvent("np-base:playerSessionStarted")
AddEventHandler("np-base:playerSessionStarted", function()

	local src = source
	local name = GetPlayerName(src)
	local user = NPX.Player:GetUser(src)
	-- local hexId = NPX.Util.GetHexId(src)
	-- local steamId = NPX.Util:HexIdToSteamId(hexId) 

	--exports["np-log"]:AddLog("Player Joined", tostring(steamId), name .. " Has joined the server", {name= name, steamid = tostring(steamId)})
	if user then exports["np-log"]:AddLog("Player Left", user, user:getVar("name").." Has joined the server") end
	print("^0" .. name .. "^7 spawned into the server")
end)

AddEventHandler("np-base:characterLoaded", function(user, char)
	local src = source
	local hexId = user:getVar("hexid")

	if char.phone_number == 0 then
		NPX.Core:CreatePhoneNumber(source, function(phonenumber, err)	
			local q = [[UPDATE characters SET phone_number = @phone WHERE owner = @owner and id = @cid]]
			local v = {
				["phone"] = phoneNumber,
				["owner"] = hexId,
				["cid"] = char.id
			}

			exports.ghmattimysql.execute(q, v, function()
				char.phone_number = math.floor(char.phone_number)
				user:setCharacter(char)
			end)
		end)
	end
end)
-- sway, jamerson, hawkeye was here 29.11.2020
-- and nikez too

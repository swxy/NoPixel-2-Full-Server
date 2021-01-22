RegisterServerEvent("npstash:RequestStashHouses")
AddEventHandler("npstash:RequestStashHouses", function()
    local q = [[SELECT * FROM stash]]

    exports.ghmattimysql:execute("SELECT * FROM stash", {}, function(result)
        if (#result > 0) then
            TriggerClientEvent("npstash:updateStashHouses", -1, result)
            print(json.encode(result))
		else
			print("ERROR happened at query (np-stash)")
		end
    end)
end)

RegisterServerEvent("npstash:requestStashCreate")
AddEventHandler("npstash:requestStashCreate", function(pData)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local character = user:getCurrentCharacter()

    exports.ghmattimysql:execute("INSERT INTO stash (owner_cid,admin,x,y,z,g_x,g_y,g_z,owner_pin,guest_pin,useGarage,tier) VALUES (@owner_cid,@admin,@x,@y,@z,@g_x,@g_y,@g_z,@owner_pin,@guest_pin,@useGarage,@tier)",{
        ['owner_cid'] = pData.owner,
        ['admin'] = pData.admin,
        ['x'] = pData.x,
        ['y'] = pData.y,
        ['z'] = pData.z,
        ['g_x'] = pData.g_x,
        ['g_y'] = pData.g_y,
        ['g_z'] = pData.g_z,
        ['owner_pin'] = pData.owner_pin,
        ['guest_pin'] = pData.guest_pin,
        ['useGarage'] = pData.garage,
        ['tier'] = pData.tier,
    })
end)

RegisterServerEvent("npstash:log")
AddEventHandler("npstash:log", function(sId, log)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local character = user:getCurrentCharacter()

    if not user then return end
    exports["np-log"]:AddLog("Stashhouse", user, log, {caller = character.id, stashid = tostring(sId)}) 
end)

AddEventHandler("np-base:spawnInitialized", function()
    TriggerEvent("npstash:RequestStashHouses")
end)
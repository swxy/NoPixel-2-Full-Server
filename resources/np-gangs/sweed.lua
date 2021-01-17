local crops = {}

RegisterServerEvent("weed:createplant")
AddEventHandler("weed:createplant", function(x,y,z, seed)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local character = user:getCurrentCharacter()
    local xyz = x,y,z

    exports.ghmattimysql:execute("INSERT INTO weed_plants (coords, seed, owner) VALUE (@coord, @seed, @owner)", {
        ['@coord'] = json.encode(xyz),
        ['@seed'] = seed,
        ['@owner'] = char.id,
    })
    crops[#crops+1] = json.encode(xyz), seed

end)

RegisterServerEvent("weed:killplant")
AddEventHandler("weed:killplant", function(dbId)
    exports.ghmattimysql:execute("DELETE FROM weed_plants WHERE id = @id", {
        ['@id'] = dbId,
    })
    -- need to remove from table at here
end)

RegisterServerEvent("weed:UpdateWeedGrowth")
AddEventHandler("weed:UpdateWeedGrowth", function(dbId, new)
	exports.ghmattimysql:Execute("UPDATE weed_plants SET growth = @new WHERE id = @db",{
        ['growth'] = new, 
        ['db'] = dbId
    })
end)

RegisterServerEvent("weed:requestTable")
AddEventHandler("weed:requestTable", function()
    exports.ghmattimysql:execute('SELECT * FROM weed_plants', {}, function(result)
        crops[#crops+1] = result
        TriggerClientEvent("weed:currentcrops", -1, result)
    end)
end)
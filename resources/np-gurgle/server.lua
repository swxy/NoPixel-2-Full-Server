local websites = {}
local price = 500

function getGurgle()
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local cid = char.id
    local data = {
        ["Title"] = title,
        ["Keywords"] = keywords,
        ["Description"] = description,
    }

    exports.ghmattimysql:execute("SELECT * FROM websites WHERE owner = @cid", {['testID'] = tonumber(cid)}, function(response)
        if response[1] == nil then
          TriggerClientEvent("DoShortHudText", src, "No websites found was found",2)
        else
           -- table.insert(websites, data)
        end
    end)
end

RegisterServerEvent('website:new')
AddEventHandler('website:new', function(title, keywords, description)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local cid = char.id
    local data = {
        ["Title"] = title,
        ["Keywords"] = keywords,
        ["Description"] = description,
    }

    if tonumber(user:getCash()) >= price then
       user:removeMoney(500)
       exports.ghmattimysql:execute('INSERT INTO websites (owner, name, keywords, description) VALUES (@owner, @name, @keywords, @description)', {
           ['owner'] = cid,
           ['name'] = title,
           ['keywords'] = keywords,
           ['description'] = description
       }, function(result)
           table.insert(websites, data)
           TriggerClientEvent('websites:updateClient', -1, websites)
       end)
    else
        TriggerClientEvent("DoShortHudText",src, "You need $"..price.." + Tax.",2)
    end

end)

RegisterServerEvent('websitesList')
AddEventHandler('websitesList', function()
    local src = source

    TriggerClientEvent('websites:updateClient', -1, websites)
end)
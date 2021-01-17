
AddEventHandler('chatMessage', function(source, name, msg)
    sm = stringsplit(msg, " ");
    local sex = ""
	if sm[1] == "/pos" then
		CancelEvent()
        TriggerClientEvent("SaveCommand", source)
    elseif sm[1] == "/menu" then
        TriggerClientEvent("np-admin:openMenu", source)
    elseif sm[1] == "/me" then
        for i = 2,#sm do
            sex = sex .. ' ' .. sm[i]
        end
        TriggerClientEvent("np-commands:meCommand", -1, tonumber(source), sex)
	end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

RegisterServerEvent("SaveCoords")
AddEventHandler("SaveCoords", function(x , y , z )
 file = io.open(GetPlayerName(source) .. "-Coords.txt", "a")
    if file then
        file:write("{" .. x .. "," .. y .. "," .. z .. "}, \n")
    end
    file:close()
end)
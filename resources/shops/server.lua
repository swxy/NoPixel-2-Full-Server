RegisterServerEvent("itemMoneyCheck")
AddEventHandler("itemMoneyCheck", function(itemType,askingPrice,location)
	local src = source
	local target = exports["np-base"]:getModule("Player"):GetUser(src)
	local character = target:getCurrentCharacter()

	local invName = "ply-"..character.id

	if (tonumber(target:getCash()) >= askingPrice) then
		target:removeMoney(askingPrice)
		if askingPrice > 0 then
			TriggerClientEvent("DoShortHudText",src, "Purchased",8)

		end
		TriggerClientEvent("player:receiveItem",src,itemType,1)

	else
		TriggerClientEvent("DoShortHudText",src, "Not enough money",2)
	end

end)

RegisterServerEvent("shop:useVM:server")
AddEventHandler("shop:useVM:server", function(locatoion)
	local src = source
	local target = exports["np-base"]:getModule("Player"):GetUser(src)
	if (tonumber(target:getCash()) >= 20) then
		TriggerClientEvent("shop:useVM:finish",src)
		target:removeMoney(20)
	else
		TriggerClientEvent("DoLongHudText",src)
		TriggerClientEvent("DoLongHudText",src,"You need 20$",2)
	end

end)

local locations = {}





local itemTypes = {}

RegisterServerEvent("take100")
AddEventHandler("take100", function(tgtsent)
	local tgt = tonumber(tgtsent)
	local target = exports["np-base"]:getModule("Player"):GetUser(tgt)
	target:removeMoney(100)
end)

RegisterServerEvent("movieticket")
AddEventHandler("movieticket", function(askingPrice)
	local src = source
	local target = exports["np-base"]:getModule("Player"):GetUser(src)

	if (tonumber(target:getCash()) >= askingPrice) then
		target:removeMoney(askingPrice)

		TriggerClientEvent("startmovies",src)


	else
		TriggerClientEvent("DoShortHudText",src, "Not enough money",2)
	end
end)

RegisterServerEvent('cash:remove')
AddEventHandler('cash:remove', function(src, amount)
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    user:removeMoney(tonumber(amount))
end)
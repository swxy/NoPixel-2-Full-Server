RegisterServerEvent("np-dirtymoney:attemptDirtyMoneyDrops")
AddEventHandler("np-dirtymoney:attemptDirtyMoneyDrops", function()
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local DirtyMoney = user:getDirtyMoney()

	if DirtyMoney > 500 then
		TriggerClientEvent("np-dirtymoney:attemptDirtyMoneyDrops",source)
		DirtyMoney = DirtyMoney - 500
		user:alterDirtyMoney(DirtyMoney)

		TriggerClientEvent('UPV',src,500)
	else
		TriggerClientEvent("DoLongHudText",source,"You need $500 in Marked Bills.",2)
	end

end)

RegisterServerEvent("np-dirtymoney:alterDirtyMoney")
AddEventHandler("np-dirtymoney:alterDirtyMoney", function(reason, amount)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local DirtyMoney = user:getDirtyMoney()

	if reason == "ItemDrop" then
		TriggerClientEvent("np-dirtymoney:attemptDirtyMoneyDrops",source)
		DirtyMoney = DirtyMoney - amount
		user:alterDirtyMoney(DirtyMoney)

		TriggerClientEvent('UPV',src,amount)
	else
		DirtyMoney = DirtyMoney + amount
		user:alterDirtyMoney(DirtyMoney)
	end

end)

RegisterServerEvent("np-dirtymoney:moneyPickup")
AddEventHandler("np-dirtymoney:moneyPickup", function(amount)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	user:addMoney((amount))
end)
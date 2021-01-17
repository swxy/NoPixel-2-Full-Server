local koil = vehicleBaseRepairCost

RegisterServerEvent('np-bennys:attemptPurchase')
AddEventHandler('np-bennys:attemptPurchase', function(cheap, type, upgradeLevel)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    if type == "repair" then
        if user:getCash() >= koil then
            user:removeMoney(koil)
            TriggerClientEvent('np-bennys:purchaseSuccessful', source)
        else
            TriggerClientEvent('np-bennys:purchaseFailed', source)
        end
    elseif type == "performance" then
        if user:getCash() >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('np-bennys:purchaseSuccessful', source)
            user:removeMoney(vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('np-bennys:purchaseFailed', source)
        end
    else
        if user:getCash() >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('np-bennys:purchaseSuccessful', source)
            user:removeMoney(vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('np-bennys:purchaseFailed', source)
        end
    end
end)

RegisterServerEvent('np-bennys:updateRepairCost')
AddEventHandler('np-bennys:updateRepairCost', function(cost)
    koil = cost
end)

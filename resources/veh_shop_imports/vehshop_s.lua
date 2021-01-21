--empty since who tf makes a server side for this shit you fucking retards @Koil--

local carTable = {
	[1] = { ["model"] = "focusrs", ["baseprice"] = 285000, ["commission"] = 15 }, 
	[2] = { ["model"] = "fnfrx7", ["baseprice"] = 275000, ["commission"] = 15 },
	[3] = { ["model"] = "r1", ["baseprice"] = 250000, ["commission"] = 15 },
	[4] = { ["model"] = "fnf4r34", ["baseprice"] = 325000, ["commission"] = 15 },
	[5] = { ["model"] = "gt63", ["baseprice"] = 375000, ["commission"] = 15 },
}
RegisterServerEvent('carshop:table2')
AddEventHandler('carshop:table', function(table)
    if table ~= nil then
        carTable = table
        TriggerClientEvent('veh_shop:returnTable2', -1, carTable)
        updateDisplayVehicles()
    end
end)

RegisterServerEvent('BuyForVeh2')
AddEventHandler('BuyForVeh2', function(platew, name, vehicle, price, financed)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(source)
    local char = user:getVar("character")
    local player = user:getVar("hexid")
    if financed then
        local cols = 'owner, cid, license_plate, name, purchase_price, financed, last_payment, model, vehicle_state, payments_left'
        local val = '@owner, @cid, @license_plate, @name, @buy_price, @financed, @last_payment, @model, @veh_state, @payments_left'
        local downPay = math.ceil(price / 4)
        exports.ghmattimysql:execute('INSERT INTO characters_cars ( '..cols..' ) VALUES ( '..val..' )',{
            ['@owner'] = player,
            ['@cid'] = char.id,
            ['@license_plate']   = platew,
            ['@model'] = vehicle,
            ['@name'] = name,
            ['@buy_price'] = price,
            ['@financed'] = price - downPay,
            ['@last_payment'] = 7,
            ['@payments_left'] = 12,
            ['@veh_state'] = "Out",
        })
    else
        exports.ghmattimysql:execute('INSERT INTO characters_cars (owner, cid, license_plate, name, model, purchase_price, vehicle_state) VALUES (@owner, @cid, @license_plate, @name, @model, @buy_price, @veh_state)',{
            ['@owner']   = player,
            ['@cid'] = char.id,
            ['@license_plate']   = platew,
            ['@name'] = name,
            ['@model'] = vehicle,
            ['@buy_price'] = price,
            ['@veh_state'] = "Out"
        })
    end
end)




RegisterServerEvent('CheckMoneyForVeh3')
AddEventHandler('CheckMoneyForVeh3', function(name, model,price,financed)
    local user = exports["np-base"]:getModule("Player"):GetUser(source)
    local money = tonumber(user:getCash())
    if financed then
        local financedPrice = math.ceil(price / 4)
        if money >= financedPrice then
            user:removeMoney(financedPrice)
            TriggerClientEvent('FinishMoneyCheckForVeh', user.source, name, model, price, financed)
        else
            TriggerClientEvent('DoLongHudText', user.source, 'You dont have enough money on you!', 2)
            TriggerClientEvent('carshop:failedpurchase', user.source)
        end
    else
        if money >= price then
            user:removeMoney(price)
            TriggerClientEvent('FinishMoneyCheckForVeh', user.source, name, model, price, financed)
        else
            TriggerClientEvent('DoLongHudText', user.source, 'You dont have enough money on you!', 2)
            TriggerClientEvent('carshop:failedpurchase', user.source)
        end
    end
end)

RegisterServerEvent('finance:enable2')
AddEventHandler('finance:enable2', function(plate)
TriggerClientEvent('finance:enableOnClient2', plate)
end)
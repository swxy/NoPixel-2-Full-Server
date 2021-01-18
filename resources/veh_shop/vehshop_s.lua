local repayTime = 168 * 60 -- hours * 60
local timer = ((60 * 1000) * 10) -- 10 minute timer

local carTable = {
	[1] = { ["model"] = "gauntlet", ["baseprice"] = 100000, ["commission"] = 15 }, 
	[2] = { ["model"] = "dubsta3", ["baseprice"] = 100000, ["commission"] = 15 },
	[3] = { ["model"] = "landstalker", ["baseprice"] = 100000, ["commission"] = 15 },
	[4] = { ["model"] = "bobcatxl", ["baseprice"] = 100000, ["commission"] = 15 },
	[5] = { ["model"] = "surfer", ["baseprice"] = 100000, ["commission"] = 15 },
	[6] = { ["model"] = "glendale", ["baseprice"] = 100000, ["commission"] = 15 },
	[7] = { ["model"] = "washington", ["baseprice"] = 100000, ["commission"] = 15 },
}

-- Update car table to server
RegisterServerEvent('carshop:table')
AddEventHandler('carshop:table', function(table)
    if table ~= nil then
        carTable = table
        TriggerClientEvent('veh_shop:returnTable', -1, carTable)
        updateDisplayVehicles()
    end
end)

-- Enables finance for 60 seconds
RegisterServerEvent('finance:enable')
AddEventHandler('finance:enable', function(plate)
    if plate ~= nil then
        TriggerClientEvent('finance:enableOnClient', -1, plate)
    end
end)

RegisterServerEvent('buy:enable')
AddEventHandler('buy:enable', function(plate)
    if plate ~= nil then
        TriggerClientEvent('buy:enableOnClient', -1, plate)
    end
end)

-- return table
-- TODO (return db table)
RegisterServerEvent('carshop:requesttable')
AddEventHandler('carshop:requesttable', function()
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    exports.ghmattimysql:execute('SELECT * FROM vehicle_display', function(result)
    print(json.encode(carTable))
    for k,v in pairs(result[1]) do
        carTable[v.id] = v
        v.price = carTable[v.id].baseprice
    end
    TriggerClientEvent('veh_shop:returnTable', user.source, carTable)
    end)
end)

-- Check if player has enough money
RegisterServerEvent('CheckMoneyForVeh')
AddEventHandler('CheckMoneyForVeh', function(name, model,price,financed)
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


-- Add the car to database when completed purchase
RegisterServerEvent('BuyForVeh')
AddEventHandler('BuyForVeh', function(vehicleProps,platew, name, vehicle, price, financed)
    print(vehicleProps)
    local user = exports["np-base"]:getModule("Player"):GetUser(source)
    local char = user:getVar("character")
    local player = user:getVar("hexid")
    if financed then
        local cols = 'owner, cid, license_plate, data, purchase_price, financed, last_payment, model, vehicle_state'
        local val = '@owner, @cid, @license_plate, @data, @buy_price, @financed, @last_payment, @model, @veh_state'
        local downPay = math.ceil(price / 4)
        exports.ghmattimysql:execute('INSERT INTO characters_cars ( '..cols..' ) VALUES ( '..val..' )',{
            ['@owner'] = player,
            ['@cid'] = char.id,
            ['@license_plate']   = platew,
            ['@data'] = json.encode(vehicleProps),
            ['@model'] = vehicle,
            ['@buy_price'] = price,
            ['@financed'] = price - downPay,
            ['@last_payment'] = repayTime,
            ['@veh_state'] = "Out"
        })
    else
        exports.ghmattimysql:execute('INSERT INTO characters_cars (owner, cid, license_plate, data, model, purchase_price, vehicle_state) VALUES (@owner, @cid, @license_plate, @data, @model, @buy_price, @veh_state)',{
            ['@owner']   = player,
            ['@cid'] = char.id,
            ['@license_plate']   = platew,
            ['@data'] = json.encode(vehicleProps),
            ['@model'] = vehicle,
            ['@buy_price'] = price,
            ['@veh_state'] = "Out"
        })
    end
end)

-- Get All finance > 0 then take 10min off
-- Every 10 Min
function updateFinance()
    exports.ghmattimysql:execute('SELECT last_payment, license_plate FROM characters_cars WHERE last_payment > @last_payment', {
        ["@financetimer"] = 0
    }, function(result)
        for i=1, #result do
            local financeTimer = result[i].financetimer
            local plate = result[i].plate
            local newTimer = financeTimer - 10
            if financeTimer ~= nil then
                exports.ghmattimysql:execute('UPDATE characters_cars SET last_payment=@last_payment WHERE license_plate=@license_plate', {
                    ['@plate'] = plate,
                    ['@financetimer'] = newTimer
                })
            end
        end
    end)
    SetTimeout(timer, updateFinance)
end
SetTimeout(timer, updateFinance)

-- RegisterNetEvent('RS7x:phonePayment')
-- AddEventHandler('RS7x:phonePayment', function(plate)
--     local src = source
--     local pPlate = plate
--     local user = exports["np-base"]:getModule("Player"):GetUser(src)
--     local group = MySQL.Sync.fetchAll("SELECT shop FROM owned_vehicles WHERE plate=@plate", {['@plate'] = plate})
--     print(group[1].shop)
--     if pPlate ~= nil then
--         local pData = MySQL.Sync.fetchAll("SELECT buy_price, plate FROM owned_vehicles WHERE plate=@plate", {['@plate'] = pPlate})
--         for k,v in pairs(pData) do
--             if pData ~= nil then
--                 if pPlate == v.plate then
--                     local price = (v.buy_price / 10)
--                     if user:getCash() >= price then
--                         user:removeMoney(price)
--                         fuck = true
--                         TriggerClientEvent('chatMessagess', src, 'IMPORTANT: ', 1, 'Please see pdm dealer for reimbursement. Take a screen shot of the payment or you will not receive any money back!')
--                         TriggerClientEvent('chatMessagess', src, 'IMPORTANT: ', 1, 'You payed $'.. price .. ' on your vehicle.')
--                     else
--                         fuck = false
--                         TriggerClientEvent('DoLongHudText', src, 'You don\'t have enough money to pay on this vehicle!', 2)
--                         TriggerClientEvent('DoLongHudText', src, 'You need $'.. price .. ' to pay for your vehicle!', 1)
--                     end

--                     if fuck then
--                         local data = MySQL.Sync.fetchAll("SELECT finance FROM owned_vehicles WHERE plate=@plate",{['@plate'] = plate})
--                         if not data or not data[1] then return; end
--                         local prevAmount = data[1].finance
--                         if prevAmount - price <= 0 or prevAmount - price <= 0.0 then
--                             settimer = 0
--                         else
--                             settimer = repayTime
--                         end
--                         if prevAmount < price then
--                             MySQL.Sync.execute('UPDATE owned_vehicles SET finance=@finance WHERE plate=@plate',{['@finance'] = 0, ['@plate'] = plate})
--                             MySQL.Sync.execute('UPDATE owned_vehicles SET financetimer=@financetimer WHERE plate=@plate',{['@financetimer'] = 0, ['@plate'] = plate})
--                         else
--                             MySQL.Sync.execute('UPDATE owned_vehicles SET finance=@finance WHERE plate=@plate',{['@finance'] = prevAmount - price, ['@plate'] = plate})
--                             MySQL.Sync.execute('UPDATE owned_vehicles SET financetimer=@financetimer WHERE plate=@plate',{['@financetimer'] = settimer, ['@plate'] = plate})
--                         end
--                     end

--                     local data = MySQL.Sync.fetchAll("SELECT money FROM addon_account_data WHERE account_name=@account_name",{['@account_name'] = group[1].shop})
--                     if not data then return; end
--                     local curSociety = data[1].money
--                     MySQL.Sync.execute('UPDATE addon_account_data SET money=@money WHERE account_name=@account_name',{['@money'] = curSociety + price,['@account_name'] = group[1].shop})
--                 end
--                 return
--             end
--         end
--     end
-- end)

function updateDisplayVehicles()
    for i=1, #carTable do
        exports.ghmattimysql:execute("UPDATE vehicle_display SET model=@model, commission=@commission, baseprice=@baseprice WHERE ID=@ID",{
            ['@ID'] = i,
            ['@model'] = carTable[i]["model"],
            ['@commission'] = carTable[i]["commission"],
            ['@baseprice'] = carTable[i]["baseprice"]
        })
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        updateDisplayVehicles()
    end
end)

--Citizen.CreateThread(function()
--    updateFinance()
--end)

--[[
        MySQL.Async.fetchAll('SELECT finance, plate FROM owned_vehicles WHERE finance < @finance', {
        ["@finance"] = os.date('%Y-%m-%d %H:%M:%S', os.time())
    }, function(result)
        local finance = result[1].finance
        local plate = result[1].plate
        if finance ~= nil then
            local reference = finance
            local daysfrom = os.difftime(os.time(), reference) / (24 * 60 * 60)
            local wholedays = math.floor(daysfrom)
            if wholedays < 0 then
                MySQL.Async.execute('UPDATE owned_vehicles SET finance = @finance WHERE plate=@plate', {
                    ['plate'] = e
                    ['@finance'] = fi
                })
            end
        end
    end)
    --MySQL.Sync.execute('UPDATE finance FROM owned_vehicles WHERE ')
]]
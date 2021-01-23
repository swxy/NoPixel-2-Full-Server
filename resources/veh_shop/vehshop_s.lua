local repayTime = 7 -- hours * 60
local timer = ((60 * 1000) * 60) -- 10 minute timer

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
AddEventHandler('BuyForVeh', function(platew, name, vehicle, price, financed)
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


RegisterServerEvent('car:dopayment')
AddEventHandler('car:dopayment', function(vehicleplate)
    PayVehicleFinance(vehicleplate)
end)

function PayVehicleFinance(vehicleplate)
    local user = exports["np-base"]:getModule("Player"):GetUser(source)
    local char = user:getVar("character")
    local player = user:getVar("hexid")

    exports.ghmattimysql:execute("SELECT * FROM `characters_cars` WHERE license_plate = @license_plate", {['license_plate'] = vehicleplate}, function(result)
       local vehiclepaymentsleft = result[1].payments_left
       local vehicletotalamount = result[1].financed
       if tonumber(result[1].last_payment) <= 0 then
       exports.ghmattimysql:execute("UPDATE characters_cars SET payments_left = @payments_left, last_payment = @last_payment WHERE license_plate = @license_plate",
          {['license_plate'] = vehicleplate,
          ['@payments_left'] = vehiclepaymentsleft - 1,
          ['@last_payment'] = 7,
        })
        exports.ghmattimysql:execute("UPDATE characters_cars SET financed = @financed WHERE license_plate = @license_plate",
        {['license_plate'] = vehicleplate,
        ['@financed'] = vehicletotalamount - vehicletotalamount / 12,
      })

      user:removeMoney(vehicletotalamount / 12)
    else
        TriggerClientEvent('DoLongHudText', user.source, 'It is Not The Due Date for The Payment', 2)
        print('faggot alert')
    end
      end)
end

function updateCarDueDates() 
    local changed = 0
    exports.ghmattimysql:execute('SELECT * FROM characters_cars', {
    }, function(result)
        for k,v in pairs(result) do
            local new_last_payment = tonumber(v.last_payment - 1)
            if new_last_payment >= 0 then
                changed = changed + 1
                exports.ghmattimysql:execute("UPDATE characters_cars SET last_payment = @timer WHERE license_plate = @license_plate",
                    {['license_plate'] = tostring(v.license_plate),
                    ['@timer'] = new_last_payment,
                })
            end
        end
        print('^1[Evolved RP] ^5Updated all Financing Due Dates for ^2' ..changed ..'^5 vehicles.^7')
    end)
end

TriggerEvent('cron:runAt', 16, 0, updateCarDueDates)

--RegisterCommand("penisfuck", function()
  --  updateCarDueDates()
---end)
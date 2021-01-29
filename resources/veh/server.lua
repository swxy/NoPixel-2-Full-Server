--server event
local degHealth = {
    ["breaks"] = 0,-- has neg effect
    ["axle"] = 0,	-- has neg effect
    ["radiator"] = 0, -- has neg effect
    ["clutch"] = 0,	-- has neg effect
    ["transmission"] = 0, -- has neg effect
    ["electronics"] = 0, -- has neg effect
    ["fuel_injector"] = 0, -- has neg effect
    ["fuel_tank"] = 0 
}

RegisterNetEvent('veh.examine')
AddEventHandler('veh.examine', function(plate)
    local _src = source

    exports.ghmattimysql:execute('SELECT * FROM characters_cars WHERE license_plate = @plate', {
        ['@plate'] = plate
      }, function (result) 
       -- print(result[1].engine_damage, result[1].body_damage)
        if result[1] ~= nil then
            --print('trgger client menu', result[1].degredation)
            TriggerClientEvent('towgarage:triggermenu',_src, result[1].degredation, result[1].engine_damage, result[1].body_damage)
        else
            TriggerClientEvent("DoLongHudText",_src, "This vehicle is not listed",2) 
        end
      end)
    
end)

RegisterNetEvent('veh.callDegredation')
AddEventHandler('veh.callDegredation', function(plate,status)

    local _src = source
    exports.ghmattimysql:execute('SELECT * FROM characters_cars WHERE license_plate = @plate', {
        ['@plate'] = plate
      }, function (result) 

        if result[1] ~= nil then
            if status == nil or status == false then
                TriggerClientEvent('veh.getSQL',_src, result[1].degredation)
            elseif status == true then
                TriggerClientEvent('towgarage:triggermenu',_src, result[1].degredation)
            end
        else
            --TriggerClientEvent("Notifications",_src, "This vehicle is not listed",2) 
        end   
        --TriggerClientEvent("veh:checkVeh",_src, degration) 
      end)
    
end)



RegisterNetEvent('veh.updateVehicleHealth')
AddEventHandler('veh.updateVehicleHealth', function(tempReturn)
    local src = source
    local plate = ""
    local engine_damage = 0
    local body_damage = 0
    local fuel = 0

    for k,v in pairs(tempReturn[1]) do
            if k == 1 then       
                plate = v
            elseif k == 2 then
                engine_damage = v
            elseif k == 3 then
                body_damage = v
            elseif k == 4 then
                fuel = v
            end
    end
    exports.ghmattimysql:execute("UPDATE characters_cars SET engine_damage = @engine_damage, body_damage = @body_damage, fuel = @fuel WHERE license_plate = @plate", {
        ['@engine_damage'] = engine_damage,
        ['@body_damage'] = body_damage,
        ['@fuel'] = fuel,
        ['@plate'] = plate
    })

end)

RegisterNetEvent('veh.updateVehicleDegredationServer')
AddEventHandler('veh.updateVehicleDegredationServer', function(plate,br,ax,rad,cl,tra,elec,fi,ft)
    if ft ~= nil then
    exports.ghmattimysql:execute('SELECT license_plate FROM characters_cars WHERE license_plate = @plate', {
        ['@plate'] = plate
      }, function (result)
       -- print(result[1].plate)
        if result[1] ~= nil then
            local degri = ""..br..","..ax..","..rad..","..cl..","..tra..","..elec..","..fi..","..ft..""  
            exports.ghmattimysql:execute("UPDATE characters_cars SET degredation = @degredation WHERE license_plate = @plate", {
                ['@degredation'] = tostring(degri),
                 ['@plate'] = plate
            })
        else
            local degri = ""..br..","..ax..","..rad..","..cl..","..tra..","..elec..","..fi..","..ft..""  
            -- print('not mine veh_damage',degri)
          
        end
      end)
    end
end)

RegisterNetEvent('veh.getVehicles')
AddEventHandler('veh.getVehicles', function(plate,veh)
    local _src = source
    exports.ghmattimysql:execute('SELECT * FROM characters_cars WHERE license_plate = @plate', {
        ['@plate'] = plate
      }, function (result)
        if result[1] ~= nil then
            TriggerClientEvent('veh.setVehicleHealth',_src, result[1].engine_damage, result[1].body_damage, result[1].fuel, veh)
        else
            --TriggerClientEvent("Notifications",_src, "This vehicle is not listed",2) 
        end
      end)
end)

function string:split(delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
    return result
  end
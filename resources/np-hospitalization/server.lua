RegisterServerEvent('stress:illnesslevel')
AddEventHandler('stress:illnesslevel', function(newval)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local newval = tonumber(newval)
    exports.ghmattimysql:execute("UPDATE hospital_patients SET level = @newval  WHERE cid = @id",{['newval'] = newval, ['id'] = char.id})
end)

RegisterServerEvent('stress:illnesslevel:new')
AddEventHandler('stress:illnesslevel:new', function(injury,lenghtofinjury)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local newval = tonumber(newval)
    exports.ghmattimysql:execute("UPDATE hospital_patients SET level = @lenghtofinjury, illness = @injury, time = @time  WHERE cid = @id",{['time'] = 60, ['injury'] = injury, ['id'] = char.id, ['lenghtofinjury'] = lenghtofinjury})
end)

local isNancyEnabled = false
RegisterServerEvent('doctor:enableTriage')
AddEventHandler('doctor:enableTriage', function()
    isNancyEnabled = true
    TriggerEvent('doctor:setTriageState')
end)

RegisterServerEvent('doctor:disableTriage')
AddEventHandler('doctor:disableTriage', function()
    isNancyEnabled = false
    TriggerEvent('doctor:setTriageState')
end)

RegisterServerEvent('doctor:setTriageState')
AddEventHandler('doctor:setTriageState', function()
    TriggerClientEvent('doctor:setTriageState', -1, isNancyEnabled)
end)
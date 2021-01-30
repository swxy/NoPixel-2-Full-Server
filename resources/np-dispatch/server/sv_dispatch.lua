


RegisterServerEvent('dispatch:svNotify')
AddEventHandler('dispatch:svNotify', function(data)
    if data.dispatchCode == "10-13A" then
        local recipientList = {
            police = "police",
            ambulance = "ambulance"
          }
          local blipSprite = 84
          local blipColor = 1
        TriggerClientEvent('dispatch:clNotify',-1,{ dispatchCode = "10-13A", callSign = data.callSign, dispatchMessage = "officer down URGENT!", firstStreet = data.firstStreet, recipientList = recipientList, playSound = true, soundName = "10-1314", isImportant = true, priority = 3, origin = data.origin, blipSprite = blipSprite, blipColor = blipColor})
    elseif data.dispatchCode == "10-13B" then
        local recipientList = {
            police = "police",
            ambulance = "ambulance"
          }
          local blipSprite = 84
          local blipColor = 3
        TriggerClientEvent('dispatch:clNotify',-1,{ dispatchCode = "10-13B", callSign = data.callSign, dispatchMessage = "Officer down", firstStreet = data.firstStreet, recipientList = recipientList, playSound = false, soundName = "10-1314", isImportant = false, priority = 3, origin = data.origin, blipSprite = blipSprite, blipColor = blipColor})
    else
    TriggerClientEvent('dispatch:clNotify',-1,data)
    --print('come here', json.encode(data))
    end
end)

RegisterCommand('togglealerts', function(source, args, user)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)

      if user:getVar("job") == 'police' or user:getVar("job") == 'ems' then
        TriggerClientEvent('dispatch:toggleNotifications', source, args[1])
    end
end)


RegisterServerEvent('AlertReckless')
AddEventHandler('AlertReckless', function(street1, gender, plate, make, color1, color2, street2)
    if color1 == 0 then color1 = 1 end
    if color2 == 0 then color2 = 2 end
    if color1 == -1 then color1 = 158 end
    if color2 == -1 then color2 = 158 end
    if color1 > 158 then
        color1 = 158
    end
    if color2 > 158 then
        color2 = 158
    end
    
    TriggerEvent('dispatch:svNotify', { dispatchCode = "10-94", gender = gender, firstStreet1 = street1, secondStreet = street2, model = make, plate = plate})
end)


RegisterServerEvent('thiefInProgressS1')
AddEventHandler('thiefInProgressS1', function(street1, gender, plate, make, color1, color2, pOrigin)
    if color1 == 0 then color1 = 1 end
    if color2 == 0 then color2 = 2 end
    if color1 == -1 then color1 = 158 end
    if color2 == -1 then color2 = 158 end
    if color1 > 158 then
        color1 = 158
    end
    if color2 > 158 then
        color2 = 158
    end
    plate = string.upper(plate)
    TriggerEvent('dispatch:svNotify', { dispatchCode = "10-60", gender = gender, firstStreet1 = street1, model = make, plate = plate, firstColor = color1, secondColor = color2, origin = pOrigin})
end)


RegisterServerEvent('OfficerEMSDown')
AddEventHandler('OfficerDown', function(dCode, Street, callSign, plySound, important, prio, pos)

    local recipientList = {
      police = "police",
      ambulance = "ambulance"
    }
    local blipSprite = 84
    local blipColor = 1


    TriggerEvent('dispatch:svNotify', { dispatchCode = "10-13A", dispatchMessage = "URGENT!", firstStreet = Street, recipientList = recipientList, playSound = plySound, isImportant = important, priority = prio, origin = pos})
end)

RegisterServerEvent('OfficerEMSDown2')
AddEventHandler('OfficerDown2', function(dCode, Street, callSign, plySound, important, prio, pos)

    local recipientList = {
      police = "police",
      ambulance = "ambulance"
    }
    local blipSprite = 84
    local blipColor = 1


    TriggerEvent('dispatch:svNotify', { dispatchCode = "10-13A", dispatchMessage = "URGENT!", firstStreet = Street, recipientList = recipientList, playSound = plySound, isImportant = important, priority = prio, origin = pos})
end)
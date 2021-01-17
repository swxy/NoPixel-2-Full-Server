local banks = {
    ["Bank1"] = { ["x"]=152.04, ["y"]=-1040.77, ["z"]= 29.37, ["robbing"] = false, ["robbingvault"] = false, ["lastRobbed"] = 1, ["rob"] = {}, ["started"] = false },
    ["Bank2"] = { ["x"]=-1212.980, ["y"]=-330.841, ["z"]= 37.787, ["robbing"] = false, ["robbingvault"] = false, ["lastRobbed"] = 1, ["rob"] = {}, ["started"] = false },
    ["Bank3"] = { ["x"]=-2962.582, ["y"]=482.627, ["z"]= 15.703, ["robbing"] = false, ["robbingvault"] = false, ["lastRobbed"] = 1, ["rob"] = {}, ["started"] = false },
    ["Bank4"] = { ["x"]=314.187, ["y"]=-278.621, ["z"]= 54.170, ["robbing"] = false, ["robbingvault"] = false, ["lastRobbed"] = 1, ["rob"] = {}, ["started"] = false },
    ["Bank5"] = { ["x"]=-351.534, ["y"]=-49.529, ["z"]= 49.042, ["robbing"] = false, ["robbingvault"] = false, ["lastRobbed"] = 1, ["rob"] = {}, ["started"] = false },
    ["Bank6"] = { ["x"]=1176.04, ["y"]=2706.339, ["z"]= 37.15, ["robbing"] = false, ["robbingvault"] = false, ["lastRobbed"] = 1, ["rob"] = {}, ["started"] = false },
  }

RegisterServerEvent("rob:doorOpen")
AddEventHandler("rob:doorOpen", function(bankId,robbing)
    local src = source
     local bank = "Bank"..bankId
    if robbing == "robbingvault" then
        local bankRob = banks[bank]
        bankRob["started"] = false
        bankRob["robbing"] = true
        bankRob["robbingvault"] = true
    TriggerClientEvent('robbery:openDoor',-1,"square")
    TriggerClientEvent('robbery:scanbank',src, bankId, banks)
    
    end
    if robbing == "robbing" then

    end
end)

RegisterServerEvent("robbery:checkSearch")
AddEventHandler("robbery:checkSearch", function(nearbank, inputType)
    local src = source
    TriggerClientEvent('robbery:giveleitem', source, nearbank, inputType)
    local bank = "Bank"..nearbank

    local bankRob = banks[bank]
    table.insert(bankRob.rob, inputType)

    TriggerClientEvent("robbery:scanbank",src,nearbank,banks)


end)
RegisterServerEvent("request:BankUpdate")
AddEventHandler("request:BankUpdate", function()
    local src = source
    local timers = {1,2,3,4,5,6}
    TriggerClientEvent('robbery:timers',src, timers)
    banks["started"] = true
    for i=1,6 do 
        local bankRob = banks['Bank'..i]
        bankRob["started"] = true

    end
    Citizen.Wait(1000)
    TriggerClientEvent('updateBanksNow',src, banks)
end)


RegisterServerEvent('robbery:shutdown')
AddEventHandler('robbery:shutdown', function(bankID)
    TriggerClientEvent('robbery:shutdownBank',-1,bankID,true)
    local bankSecured = banks[bank]
    bankSecured["started"] = false
    TriggerClientEvent("robbery:closeDoor", -1, "square")
 end)

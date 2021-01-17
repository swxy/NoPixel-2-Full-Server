RegisterServerEvent('mission:completed')
AddEventHandler('mission:completed', function(money)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(source)
    user:addMoney(money)
end)

RegisterServerEvent('mission:caughtMoney')
AddEventHandler('mission:caughtMoney', function(rnd)
    local user = exports["np-base"]:getModule("Player"):GetUser(source)
    user:addMoney(rnd)
end)

RegisterCommand('ooc', function(source, args)
    if not args[1] then return end
    local src = source
    local msg = ""
    for i = 1, #args do
      msg = msg .. " " .. args[i]
    end
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local name = char.first_name .. " " .. char.last_name
    TriggerClientEvent( "chatMessage",-1 , "OOC " .. name ,2 , msg)
    exports["np-log"]:AddLog("OOC Chat [".. src .."]", user, name .. ": " .. msg, {})
    print(tostring(msg))
end)


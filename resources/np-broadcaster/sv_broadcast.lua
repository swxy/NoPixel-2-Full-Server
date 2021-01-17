RegisterServerEvent('attemptBroadcast')
AddEventHandler('attemptBroadcast', function()
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local jobs = exports["np-base"]:getModule("JobManager")
    local jobs = exports["np-base"]:getModule("JobManager"):CountJob("broadcaster")
    if activeBroadcast >= 5 then TriggerClientEvent("DoLongHudText",src, "There is already too many broadcasters here",2) end
    jobs:SetJob(user, "broadcaster", false, function()
        TriggerClientEvent("broadcast:becomejob",src)
    end)
end)
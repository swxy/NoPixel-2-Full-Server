RegisterServerEvent("job:Pay")
AddEventHandler("job:Pay", function(data,pay)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    
end)

RegisterServerEvent("secondary:NewJobServer")
AddEventHandler("secondary:NewJobServer", function(newjob)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()

        exports.ghmattimysql:execute('INSERT INTO secondary_jobs (cid, job) VALUES (@cid, @job)', {
            ['cid'] = char.id,
            ['job'] = newjob,
        }, function(result)
            TriggerClientEvent('SecondaryJobUpdate', src, newjob)
        end)
end)

RegisterServerEvent("secondary:NewJobServerWipe")
AddEventHandler("secondary:NewJobServerWipe", function()
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()

    exports.ghmattimysql:execute('DELETE FROM secondary_jobs WHERE cid = @cid', {
        ['cid'] = char.id,
    }, function(result)
        TriggerClientEvent('SecondaryJobUpdate', src, "none")
    end)
end)
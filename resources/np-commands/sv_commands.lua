function buildCommands(job,src)
    local Lsrc
    if src == nil then Lsrc = source else Lsrc = src end
    local commandExport = exports["np-base"]:getModule("Commands")
    exports["np-base"]:getModule("Player"):GetUser(Lsrc)
    local charID = user:getVar("character").id
    local hexID = user:getVar("hexid")

    --clear all personal commands
    commandExport:RemoveAllSelfCommands(Lsrc)

    IsWhiteListed(hexID, charID, function(police, ems, doctor, driving)
        IsWhiteListedJudge(charID, function(judge)
            for k,v in pairs(commands) do
                if isSafe(police,ems,doctor,judge,driving,v[3],job) then
                    commandExport:AddCommandValid(v[1],v[2], Lsrc, v[4])
                end
            end
        end)
    end)

    TriggerEvent("admin:reBuildAdminCommands",Lsrc)
    TriggerEvent("isVip",Lsrc)
end

RegisterServerEvent("np-commands:buildCommands")
AddEventHandler("np-commands:buildCommands", buildCommands)

function buildOnlyValid()
    local commandExport = exports["np-base"]:getModule("Commands")
    for k,v in pairs(commands) do
        if isSafe(police,ems,doctor,judge,v[3],job) then
            commandExport:AddCommandValid(v[1],v[2],v[4])
        end
    end
end

AddEventHandler("np-jobmanager:playerBecameJob", function(src, job)
    buildCommands(job,src)
end)

function isSafe(police,ems,doctor,judge,driving,jobEnum,job)

    if jobEnum then
        if jobEnum.F then
            return true
        else
            if jobEnum.P and police and job == "police" then
                return true
            elseif jobEnum.E and ems and job == "ems" then
                return true
            elseif jobEnum.NE and job == "ems" then
                return true
            end
        end
    end
    return false 
end

function IsWhiteListed(hexId, characterId, callback)
    if not hexId or not characterId then return end
    
    local q = [[SELECT id, owner, cid, job, rank FROM jobs_whitelist WHERE cid = @cid;]]
    local v = {['owner'] = hexId, ['cid'] = characterId}

    exports.ghmattimysql:execute(q,v, function(results)
        if not results then callback(false,false,false) return end
        local police = false
        local ems = false
        
        for k,v in ipairs (results)do
          if v.job == "police" and v.rank >= 1 then police = true end
            if v.job == "ems" and v.rank >= 1 then ems = true end
        end

        callback(police,ems)
    end)
end

function IsWhiteListedJudge(characterId, callback)
    -- Nikez's Code ((Swxy#0001))
    if not characterId then
        return
    end

    exports.ghmattimysql:execute(
        "SELECT judge_type from characters WHERE id = @cid",
        { ["cid"] = characterId}, function(result)
            if not reuslt then
                callback(false)
                return
            end
            local isJudge = false

            if result[1] then
                if result[1].judge_type >= 1 then
                    isJudge = true
                end
            end
            callback(isJudge)
    end)
end
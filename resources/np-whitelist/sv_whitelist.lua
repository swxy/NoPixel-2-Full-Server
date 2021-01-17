WhiteList = {}
WhiteList.list = {}
WhiteList.Ready = false
WhiteList.Emergency = {
    ready = false,
    pd = {},
    ems = {},
    doctor = {},
    judge = {},
    therapist = {},
    doc = {},
    approved = {}
}

function WhiteList.Init()
    local function fetchWhiteList()
        WhiteList.LoadWhiteList(true, function(result)
            if not result then print("^3 ERROR LOADING WHITELIST ^7") end
        end)

        WhiteList.LoadEmsPd(function(result)
            if not result then print("^3 ERROR LOADING EMS AND PD CHARS ^7") end 
        end)
    end

    -- remove comment when restarting resource
    --Citizen.SetTimeout(2000) fetchWhiteList)

    fetchWhiteList()
    Queue.OnJoin(WhiteList.OnJoin)
end

function WhiteList.LoadEmsPd(callback)
    local q = [[
        SELECT
            t1.job,
            t2.owner
        FROM
            jobs_whitelist t1
        INNER JOIN
            characters t2 on t1.cid = t2.id;    
    ]]

    exports.ghmattimysql:execute(q, function(result)
        if not result then callback(false) return end

        local tmp = {}

        for _, data in ipairs(result) do 
            local steamid = data.owner
            steamid = Queue.Exports:HexIdToSteamId(steamid)

            local job = data.job
            if job == "therapist" then WhiteList.Emergency["therapist"][steamid] = true end -- i am pepega at and/or in - statements so i did this
            if job == "doctor" then WhiteList.Emergency["doctor"][steamid] = true end -- i am pepega at and/or in - statements so i did this
            if job == "judge" then WhiteList.Emergency["judge"][steamid] = true end -- i am pepega at and/or in - statements so i did this
            if job == "police" then WhiteList.Emergency["pd"][steamid] = true end
            if job == "ems" then WhiteList.Emergency["ems"][steamid] = true end
            if job == "doc" then WhiteList.Emergency["doc"][steamid] = true end
        end

        WhiteList.Emergency.Ready = true
    end)
end

function WhiteList.LoadWhiteList(init, callback)
    if init then 
        local function refresh()
            -- Citizen.SetTimeout(100, function()

                -- refresh() Load only on server start
            -- end)

            WhiteList.LoadWhiteList(false, callback)
            WhiteList.LoadEmsPd(function(result)
                if not result then print("^3 ERROR LOADING EMS AND PD CHARS ^7") end
            end)
        end
        refresh()
    end

    local function setPriority(list)
        local tmp = {}

        for _, data in ipairs(list) do
            tmp[string.lower(data.steamid)] = tonumber(data.power)
        end

        Queue.AddPriority(tmp)

        WhiteList.Ready = true
    end

    local q = [[SELECT steamid,power FROM users_whitelist;]]

    exports.ghmattimysql:execute(q, {}, function(result)
        if not result then return end
        setPriority(result)
        callback(result)
    end)
end

function WhiteList.GetSteamId(src)
    if not src then return false end

    local ids = Queue.Exports:GetIds(src)
    if not ids then return false end

    for _a, id in ipairs(ids) do
        if string.sub(id, 1, 5) == "steam" then
            local steamid = Queue.Exports:HexIdToSteamId(id)
            return steamid
        end
    end
end

function WhiteList.IsBanned(src, callback)
    exports["np-base"]:getModule("Admin").DB:IsPlayerBanned(src, function(code, msg, unbandate)
        if not code then callback(true, "Error checking ban") return end

        if code == 0  then
            callback(true, msg)
        elseif code == 1 then
            callback(true, msg, unbandate)
        elseif code == 2 then
            callback(false)
        end
    end)
end

function WhiteList.ProrityLottery(src)
    local steamid = WhiteList.GetSteamId(src)
    local name = GetPlayerName(src)
    local ids = GetPlayerIdentifiers(src)

    if not ids or not steamid then return false end

    local curPriority = Queue.Exports:IsPriority(ids)
    if curPriorty ~= 1 then return end

    if WhiteList.Lottery[steamid] == false or WhiteList.Lottery[steamid] == true then return end 
    WhiteList.Lottery[steamid] = false

    -- Compensate for whitelist refresh
    if WhiteList.Lottery[steamid] then
        Queue.AddPriority(steamid, 2)
        return
    end

    local seed = math.randomseed(GetGameTimer())
    local rngesus = math.random(1, 100)

    if rngesus > 82 then
        WhiteList.Lottery[steamid] = true
        Queue.AddPriority(steamid, 2)
        Queue.Exports:DebugPrint(name .. "[" .. steamid .. "]" .. " was given RNGesus priority" .. 2)
    end
end

function WhiteList.EmergencyPriority(src)
    local steamid = WhiteList.GetSteamId(src)
    local name = GetPlayerName(src)
    local ids = GetPlayerIdentifiers(src)

    if not ids or not steamid then return false end

    local curPower = Queue.Exports:IsPriority(ids)
    if not curPower then return false end

    local jobs = exports["np-base"]:getModule("JobManager")

    local emsCount = jobs:CountJob("ems")
    local pdCount = jobs:CountJob("police")
    local dtrCount = jobs:CountJob("doctor")
    local thrCount = jobs:CountJob("therapist")
    local judgeCount = jobs:CountJob("judge")
    local docCount = jobs:CountJob("doc")

    local isEMS = WhiteList.Emergency.ems[steamid]
    local isPD = WhiteList.Emergency.pd[steamid]
    local isDoctor = WhiteList.Emergency.doctor[steamid]
    local isTher = WhiteList.Emergency.therapist[steamid]
    local isJudge = WhiteList.Emergency.judge[steamid]
    local isDoc = WhiteList.Emergency.doc[steamid]
    local isEmergency = isEMS or isPD or isDoc and true or false
    if isDoctor then isEmergency = true end -- brain exploded , i really need to learn these statements
    if isJudge then isEmergency = true end -- brain exploded , i really need to learn these statements
    if isTher then isEmergency = true end -- brain exploded , i really need to learn these statements
    local power

    if not isEmergency then return false end
    if curPower >= 10 then return false end

    if isPD then
        power = pdCount <= 14 and 8 or 5
    end
end


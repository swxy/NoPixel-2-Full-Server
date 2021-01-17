function AddLog(lType, user, log, data)
    if not lType then lType = "None" else lType = tostring(lType) end
    
    if lType == "Exploiter" then
        exports["np-base"]:getModule("Admin"):ExploitAlertDiscord(user, log)
    end

    local steamId = (user and type(user) ~= "string") and user["steamid"] or (user and user or "Unknown")

    local cid = nil

    -- if type(user) ~= "string" then
    --     local char = user:getCurrentCharacter()
    --     cid = char and char.id or 0
    -- end

    log = log and tostring(log) or "None"
    data = data and json.encode(data) or "None"

    local q = [[INSERT INTO logs (type, log, data, cid, steam_id) VALUES (@type, @log, @data, @cid, @steam_id);]]

    local v = {
        ["type"] = lType,
        ["log"] = log,
        ["data"] = data,
        ["cid"] = 0,
        ["steam_id"] = steamId
    }

    exports.ghmattimysql:execute(q, v)
end

-- function AddExploiterLog(user, log, data)
--     local steamId = (user and type(user) ~= "string") and user:getVar("steamid") or (user and user or "Unknown")
--     local cid = nil
--     if type(user) ~= "string" then
--         local char = user:getCurrentCharacter()
--         cid = char and char.id or 0
--     end
--     log = log and tostring(log) or "None"
--     data = data and json.encode(data) or "None"
--     local q = [[INSERT INTO exploiters (type, log, data, cid, steam_id) VALUES (@type, @log, @data, @cid, @steam_id);]]
--     local v = {
--         ["type"] = "Exploiter",
--         ["log"] = log,
--         ["data"] = data,
--         ["cid"] = cid,
--         ["steam_id"] = steamId
--     }
--     exports.ghmattimysql:execute(q, v)
-- end
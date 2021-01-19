local GridSize, EdgeSize = Config.gridSize, Config.gridEdge
CurrentGridTarget = 3
CurrentGrids, PreviousGrid = {}, 0
edgeGrids = {}
local bitShift = 8 --2
local deltas = {
    vector2(-1, -1),
    vector2(-1, 0),
    vector2(-1, 1),
    vector2(0, -1),
    vector2(1, -1),
    vector2(1, 0),
    vector2(1, 1),
    vector2(0, 1),
}

function GridToChannel(vectors)
    return (vectors.x << bitShift) | vectors.y
end

function GetGridChunk(coords)
    return math.floor((coords + 8192) / GridSize)
end

function GetGridChannel(coords, intact)
    local grid = vector2(GetGridChunk(coords.x), GetGridChunk(coords.y))
    local channel = GridToChannel(grid)

    -- print(intact)
    -- print(CurrentInstance)

    if not intact and CurrentInstance ~= 0 then
        print('DIO')
        channel = tonumber(("%s0%s"):format(channel, CurrentInstance))
    end

    return channel
end

function GetTargetChannels(coords, edge, currentGrid)
    local targets = {}

    for _, delta in ipairs(deltas) do
        local vectors = vector2(coords.x + delta.x * edge, coords.y + delta.y * edge)
        local channel = GetGridChannel(vectors)

        if not table.exist(targets, channel) then --and channel ~= currentGrid
            table.insert(targets, channel)
        end
    end

    return targets
end

function SetGridChannels(currentGrid, current, previous)
    --local gridTarget = _C(CurrentGridTarget == 3, 4, 3)
   -- MumbleClearVoiceTargetChannels(CurrentTarget)
    --MumbleClearVoiceTarget(CurrentTarget)
   -- MumbleSetVoiceTarget(CurrentTarget)
   MumbleClearVoiceTargetChannels(CurrentTarget)
   AddChannelGroupToTargetList(current, "grid")
   --MumbleSetVoiceTarget(CurrentTarget)
     if IsDifferent(previous, current) then
         Debug("[Grid] Current Grid: %s | Edge: %s", currentGrid, current)
        local toRemove = {}

        for _, grid in ipairs(previous) do
            if not table.exist(current, grid) then
                toRemove[#toRemove + 1] = grid
            end
        end
        RemoveChannelGroupFromTargetList(toRemove, "grid")
    --     --MumbleClearVoiceTargetChannels(CurrentTarget)
     end

    CurrentGrids = current
end

function LoadGridModule()
    RegisterModuleContext("grid", 0)
    UpdateContextVolume("grid", -1.0)

    Citizen.CreateThread(function()
        while true do
            local idle = 250 --100

            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local currentGrid = GetGridChannel(PlayerCoords)
            local edgeGrids = GetTargetChannels(PlayerCoords, EdgeSize, currentGrid)

            SetGridChannels(currentGrid, edgeGrids, CurrentGrids)

            if currentGrid ~= PreviousGrid then
                SetVoiceChannel(currentGrid)
            end

            PreviousGrid = currentGrid
    
            Citizen.Wait(idle)
        end
    end)

    TriggerEvent("np:voice:grids:ready")

    Debug("[GRID] Module Loaded")
end


-- function refreshTest()
--     SetGridChannels(currentGrid, current, previous)

--     local PlayerCoords = GetEntityCoords(PlayerPedId())
--     local currentGrid = GetGridChannel(PlayerCoords)
--     local edgeGrids = GetTargetChannels(PlayerCoords, EdgeSize, currentGrid)

--     SetGridChannels(currentGrid, edgeGrids, CurrentGrids)

-- end

-- function nearbyGridsThread()
--     Citizen.CreateThread(function()
--         while true do
--             MumbleClearVoiceTarget(CurrentTarget)
--                 for _, channel in pairs(edgeGrids) do
--                    -- print(channel)
--                    MumbleAddVoiceTargetChannel(CurrentTarget, channel)
--                 end
--             MumbleSetVoiceTarget(CurrentTarget)
    
--             Citizen.Wait(200)
--         end
--     end)
-- end
RadioChannel = {}

function RadioChannel:new (radioID)
    local this = {}

    this.id = radioID
    this.serverID = GetPlayerServerId(PlayerId())

    this.subscribers = {}

    self.__index = self

    return setmetatable(this, self)
end

function RadioChannel:subscriberExists(serverID)
    return self.subscribers[serverID] ~= nil
end

function RadioChannel:addSubscriber(serverID)
    if not self:subscriberExists(serverID) and self.serverID ~= serverID then
        self.subscribers[serverID] = serverID
    end
end

function RadioChannel:removeSubscriber(serverID)
    if self:subscriberExists(serverID) then
        self.subscribers[serverID] = nil
    end
end
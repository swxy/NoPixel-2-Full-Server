Context = {}

function Context:new()
    local this = {}

    this.contexts = {}
    this.data = {}

    self.__index = self

    return setmetatable(this, self)
end

function Context:registerContext(context)
    self.contexts[context] = {}
    self.data[context] = {}
end

function Context:contextExists(context)
    return self.contexts[context] ~= nil
end

function Context:add(targetID, context)
    if self.contexts[context] and not self:targetContextExist(targetID, context) then
        self.contexts[context][targetID] = true
    end
end

function Context:remove(targetID, context)
    if self.contexts[context] and self:targetContextExist(targetID, context) then
        self.contexts[context][targetID] = nil--false TEST
    end
end

function Context:targetContextExist(targetID, context)
    if self.contexts[context] then
        return self.contexts[context][targetID] == true
    end
end

function Context:targetHasAnyActiveContext(targetID)
    for _, context in pairs(self.contexts) do
        if context[targetID] then
            return true
        end
    end

    return false
end

function Context:getTargetContexts(targetID)
    local contexts, data = {}, {}

    for context, _ in pairs(self.contexts) do
        if self:targetContextExist(targetID, context) then
            contexts[#contexts + 1] = context
            data[context] = self.data[context]
        end
    end

    return contexts, data
end

function Context:setContextData(context, key, value)
    if self.contexts[context] then
        self.data[context][key] = value
    end
end

function Context:getContextData(context, key)
    return self.data[context][key]
end

function Context:contextIterator(func)
    for context, targets in pairs(self.contexts) do
        for targetID, active in pairs(targets) do
            if active then
                func(targetID, context)
            end
        end
    end
end
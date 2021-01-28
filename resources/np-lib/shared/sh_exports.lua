ExportsWraper = {}

function ExportsWraper:new()
    self.__index = function(_,key)
        return self:call(key)
    end

    self.__newindex = function(_, key, value)
        if type(value) == 'function' then
            ExportsWraper:register(key, value)
        end
    end

    self.__call = function (_, name, cb)
        self:register(name, cb)
    end

    return setmetatable({}, self)
end

function ExportsWraper:Packer(...)
    local params, pack = {...} , {}

    for i = 1, 15, 1 do
        pack[i] = {param = params[i]}
    end

    return pack
end

function ExportsWraper:UnPacker(params, index)
    local idx = index or 1

    if idx <= #params then
        return params[idx]["param"], self:UnPacker(params, idx + 1)
    end
end

function ExportsWraper:register(name, cb)
    exports(name, function (...)
        return self:Packer(cb(...))
    end)
end

function ExportsWraper:call(pExport)
    self.__index = function(_,key)
        return function (...)
            return self:UnPacker(exports[pExport][key](...))
        end
    end

    self.__newindex = function(_, key, value)
        return
    end

    return setmetatable({}, self)
end

ecall = ExportsWraper:new()
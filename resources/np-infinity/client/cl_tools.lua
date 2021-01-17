function PromiseTimeout(time)
    local timeout = promise:new()

    Citizen.SetTimeout(time or 1000, function ()
        timeout:resolve(false)
    end)

    return timeout
end
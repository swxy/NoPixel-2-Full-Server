RegisterServerEvent("jewel:hasrobbed")
AddEventHandler("jewel:hasrobbed", function(num)
    hasrobbed[num] = true
    TriggerClientEvent("jewel:robbed",-1,hasrobbed)
end)

RegisterServerEvent("jewel:request")
AddEventHandler("jewel:request", function()
    resetJewels()
end)

function resetJewels()
    hasrobbed = {}
    hasrobbed[1] = false
    hasrobbed[2] = false
    hasrobbed[3] = false
    hasrobbed[4] = false
    hasrobbed[5] = false
    hasrobbed[6] = false
    hasrobbed[7] = false
    hasrobbed[8] = false
    hasrobbed[9] = false
    hasrobbed[10] = false
    hasrobbed[11] = false
    hasrobbed[12] = false
    hasrobbed[13] = false
    hasrobbed[14] = false
    hasrobbed[15] = false
    hasrobbed[16] = false
    hasrobbed[17] = false
    hasrobbed[18] = false
    hasrobbed[19] = false
    hasrobbed[20] = false
    TriggerClientEvent("jewel:robbed",-1,hasrobbed)
    SetTimeout(4800000, resetJewels)
end



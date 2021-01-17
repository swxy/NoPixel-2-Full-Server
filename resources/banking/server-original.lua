require "resources/mysql-async/lib/MySQL"

-- HELPER FUNCTIONS
function bankBalance(player)
    return tonumber(MySQL.Sync.fetchScalar("SELECT bankbalance FROM users WHERE identifier = @name",
        { ['@name'] = player }))
end

function deposit(player, amount)
    local bankbalance = bankBalance(player)
    local new_balance = bankbalance + amount
    MySQL.Sync.execute("UPDATE users SET `bankbalance`= @amount WHERE identifier = @identifier",
        { ['@amount'] = new_balance, ['@identifier'] = player })
end

function withdraw(player, amount)
    local bankbalance = bankBalance(player)
    local new_balance = bankbalance - amount
    MySQL.Sync.execute("UPDATE users SET `bankbalance` = @amount WHERE identifier = @identifier",
        { ['@amount'] = new_balance, ['@identifier'] = player })
end

function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.abs(math.floor(num * mult + 0.5) / mult)
end


-- Check Bank Balance
-- TriggerEvent('es:addCommand', 'checkbalance', function(source, args, user)
    -- TriggerEvent('es:getPlayerFromId', source, function(user)
        -- local player = user.identifier
        -- local bankbalance = bankBalance(player)
        -- TriggerClientEvent("banking:updateBalance", source, bankbalance)
        -- CancelEvent()
    -- end)
-- end)

-- Bank Deposit
-- TriggerEvent('es:addCommand', 'deposit', function(source, args, user)
    -- local amount = ""
    -- local player = user.identifier
    -- for i = 1, #args do
        -- amount = args[i]
    -- end
    -- TriggerClientEvent('bank:deposit', source, amount)
-- end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local rounded = round(tonumber(amount), 0)
    if (string.len(rounded) >= 9) then
        TriggerClientEvent('showNotify', source, 'Amount is too high.')
        CancelEvent()
    else
        if (tonumber(rounded) <= tonumber(user:money)) then
            user:removeMoney((rounded))
            local player = user.identifier
            deposit(player, rounded)
            local new_balance = bankBalance(player)
            TriggerClientEvent("banking:updateBalance", source, new_balance)
            TriggerClientEvent("banking:addBalance", source, rounded)
            CancelEvent()
        else
            TriggerClientEvent('showNotify', source, 'Vous n\'avez ~r~pas assez~w~ d\'argent.')
            CancelEvent()
        end
    end
end)

RegisterServerEvent('bank:depositSalary')
AddEventHandler('bank:depositSalary', function(amount)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local rounded = round(tonumber(amount), 0)
        if (string.len(rounded) >= 9) then
            TriggerClientEvent('showNotify', source, 'Montant ~r~trop grand~w~.')
            CancelEvent()
        else
            local player = user.identifier
            deposit(player, rounded)
            local new_balance = bankBalance(player)
            TriggerClientEvent("banking:updateBalance", source, new_balance)
            TriggerClientEvent("banking:addBalance", source, rounded)
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Salaire reçu : ~g~$" .. amount)
            CancelEvent()
        end
    end)
end)

-- Bank WithdrawAmende
RegisterServerEvent('bank:withdrawAmende')
AddEventHandler('bank:withdrawAmende', function(amount)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        withdraw(player, amount)
        local new_balance = bankBalance(player)
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Nouveau solde : ~g~$" .. new_balance)
        TriggerClientEvent("banking:updateBalance", source, new_balance)
        TriggerClientEvent("banking:removeBalance", source, amount)
        CancelEvent()
    end)
end)

-- Bank Withdraw
-- TriggerEvent('es:addCommand', 'withdraw', function(source, args, user)
    -- local amount = ""
    -- local player = user.identifier
    -- for i = 1, #args do
        -- amount = args[i]
    -- end
    -- TriggerClientEvent('bank:withdraw', source, amount)
-- end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local rounded = round(tonumber(amount), 0)
        if (string.len(rounded) >= 9) then
            TriggerClientEvent('showNotify', source, 'Montant ~r~trop grand~w~.')
            CancelEvent()
        else
            local player = user.identifier
            local bankbalance = bankBalance(player)
            if (tonumber(rounded) <= tonumber(bankbalance)) then
                withdraw(player, rounded)
                user:addMoney((rounded))
                local new_balance = bankBalance(player)
                TriggerClientEvent("banking:updateBalance", source, new_balance)
                TriggerClientEvent("banking:removeBalance", source, rounded)
                CancelEvent()
            else
                TriggerClientEvent('showNotify', source, 'Vous n\'avez ~r~pas assez~w~ d\'argent.')
                CancelEvent()
            end
        end
    end)
end)

-- Bank Transfer
-- TriggerEvent('es:addCommand', 'transfer', function(source, args, user)
    -- local fromPlayer
    -- local toPlayer
    -- local amount
    -- if (args[2] ~= nil and tonumber(args[3]) > 0) then
        -- fromPlayer = tonumber(source)
        -- toPlayer = tonumber(args[2])
        -- amount = tonumber(args[3])
        -- TriggerClientEvent('bank:transfer', source, fromPlayer, toPlayer, amount)
    -- else
        -- TriggerClientEvent('chatMessage', source, "", { 0, 0, 200 }, "^1Use format /transfer [id] [amount]^0")
        -- return false
    -- end
-- end)

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(fromPlayer, toPlayer, amount)
    if tonumber(fromPlayer) == tonumber(toPlayer) then
        TriggerClientEvent('showNotify', source, 'Vous ne pouvez pas vous transférer votre propre argent.')
        CancelEvent()
    else
        TriggerEvent('es:getPlayerFromId', fromPlayer, function(user)
            local rounded = round(tonumber(amount), 0)
            if (string.len(rounded) >= 9) then
                TriggerClientEvent('showNotify', source, 'Montant ~r~trop grand~w~.')
                CancelEvent()
            else
                local player = user.identifier
                local bankbalance = bankBalance(player)
                if (tonumber(rounded) <= tonumber(bankbalance)) then
                    withdraw(player, rounded)
                    local new_balance = bankBalance(player)
                    TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Transféré : ~r~-$" .. rounded .. " ~n~ ~s~Solde : ~g~$" .. new_balance)
                    TriggerClientEvent("banking:updateBalance", source, new_balance)
                    TriggerClientEvent("banking:removeBalance", source, rounded)
                    TriggerEvent('es:getPlayerFromId', toPlayer, function(user2)
                        local recipient = user2.identifier
                        deposit(recipient, rounded)
                        new_balance2 = bankBalance(recipient)
                        TriggerClientEvent("es_freeroam:notify", toPlayer, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Reçu : ~g~$" .. rounded .. " ~n~ ~s~Solde : ~g~$" .. new_balance2)
                        TriggerClientEvent("banking:updateBalance", toPlayer, new_balance2)
                        TriggerClientEvent("banking:addBalance", toPlayer, rounded)
                        CancelEvent()
                    end)
                    CancelEvent()
                else
                    TriggerClientEvent('showNotify', source, 'Vous n\'avez ~r~pas assez~w~ d\'argent.')
                    CancelEvent()
                end
            end
        end)
    end
end)

-- Give Cash (should be removed when menu testing is bulletproof) --
-- TriggerEvent('es:addCommand', 'givecash', function(source, args, user)
    -- local fromPlayer
    -- local toPlayer
    -- local amount
    -- if (args[2] ~= nil and tonumber(args[3]) > 0) then
        -- fromPlayer = tonumber(source)
        -- toPlayer = tonumber(args[2])
        -- amount = tonumber(args[3])
        -- TriggerClientEvent('bank:givecash', source, toPlayer, amount)
    -- else
        -- TriggerClientEvent('chatMessage', source, "", { 0, 0, 200 }, "^1Use format /givecash [id] [amount]^0")
        -- return false
    -- end
-- end)

RegisterServerEvent('bank:givecash')
AddEventHandler('bank:givecash', function(toPlayer, amount)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        if (tonumber(user.money) >= tonumber(amount)) then
            local player = user.identifier
            user:removeMoney(amount)
            TriggerEvent('es:getPlayerFromId', toPlayer, function(recipient)
                recipient:addMoney(amount)
                TriggerClientEvent("showNotify", source, "Vous avez donné ~r~" .. amount .. "$~w~ à ~b~" .. GetPlayerName(toPlayer) .. "~w~.")
                TriggerClientEvent("showNotify", toPlayer, "Vous avez reçu ~g~" .. amount .. "$~w~ de la part de ~b~" .. GetPlayerName(source) .. "~w~.")
            end)
        else
            if (tonumber(user.money) < tonumber(amount)) then
                TriggerClientEvent('showNotify', source, 'Vous n\'avez ~r~pas assez~w~ d\'argent.')
                CancelEvent()
            end
        end
    end)
end)

AddEventHandler('es:playerLoaded', function(source)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        TriggerClientEvent("banking:updateBalance", source, bankBalance(user.identifier))
    end)
end)
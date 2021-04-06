local recentconvictions = {}
votingEnabled = false
mayorid = 0
mayortax = 0
FundsToAdd = 0
CurrentFunds = 0

RegisterServerEvent('showbusinesses')
AddEventHandler('showbusinesses', function(businessString)
  local src = source
  TriggerClientEvent('outlawNotifyBusiness', -1, src, businessString)
end)


RegisterServerEvent('votesystem:removefunds')
AddEventHandler('votesystem:removefunds', function(amount)
  FundsToAdd = FundsToAdd - amount
  FundsToAdd = math.floor(FundsToAdd)
end)

FundsToAdd = 0
CurrentFunds = 0
RegisterServerEvent('votesystem:addfunds')
AddEventHandler('votesystem:removefunds', function(amount)
  FundsToAdd = FundsToAdd + amount
  FundsToAdd = math.floor(FundsToAdd)
end)

RegisterServerEvent('getLatestPayBonus')
AddEventHandler('getLatestPayBonus', function()
  policebonus = 0
  emsbonus = 0
  civbonus = 0
  TriggerEvent("updatePays",policebonus,emsbonus,civbonus)
end)

function runPaySystem()
  TriggerEvent("getLatestPayBonus")
  --checkmayor()
  updateCurrentTax()
  checkLastValue()
  AddFunds()
  updateMayorId()
end



local hotSpots = {
  ["Strawberry"] = { ["ratio"] = 0, ["zone"] = 1},
  ["Rancho"] = { ["ratio"] = 0, ["zone"] = 1},
  ["Chamberlain Hills"] = { ["ratio"] = 0, ["zone"] = 1},
  ["Davis"] = { ["ratio"] = 0, ["zone"] = 1},
  ["West Vinewood"] = { ["ratio"] = 0, ["zone"] = 2},
  ["Downtown Vinewood"] = { ["ratio"] = 0, ["zone"] = 2},
} 

RegisterNetEvent('drugs:hotSpots')
AddEventHandler('drugs:hotSpots', function(newhotSpots)
  hotSpots = newhotSpots
end)

local notDone = true
local startTime = os.time()

function RandomizeHotSpots()
  startTime = os.time()
  notDone = false
  hotSpots = {
    ["Strawberry"] = { ["ratio"] = 0, ["zone"] = 1},
    ["Rancho"] = { ["ratio"] = 0, ["zone"] = 1},
    ["Chamberlain Hills"] = { ["ratio"] = 0, ["zone"] = 1},
    ["Davis"] = { ["ratio"] = 0, ["zone"] = 1},
    ["West Vinewood"] = { ["ratio"] = 0, ["zone"] = 2},
    ["Downtown Vinewood"] = { ["ratio"] = 0, ["zone"] = 2},
  }

  local oneset = false
  if math.random(100) > 70 then
    oneset = true
    hotSpots["Strawberry"]["ratio"] = math.random(50,100)
  end
  if math.random(100) > 70 then
    oneset = true
    hotSpots["Rancho"]["ratio"] = math.random(50,100)
  end

  if not oneset then
    hotSpots["Chamberlain Hills"]["ratio"] = math.random(50,100)
  end

  if math.random(100) > 70 then
    oneset = true
    hotSpots["Davis"]["ratio"] = math.random(50,100)
  end
  if math.random(100) > 50 then
    hotSpots["West Vinewood"]["ratio"] = math.random(50,100)
  else
    hotSpots["Downtown Vinewood"]["ratio"] = math.random(50,100)
  end
end

function gangCoords(gangType,src)
  src = tonumber(src)
  gangType = tonumber(gangType)
  if gangType == 1 then
    gangtable = "gunrunner_farming"
  elseif gangType == 2 then
    gangtable = "cocaine_farming"
  elseif gangType == 3 then
    gangtable = "launder_farming"
  end
  exports.ghmattimysql.execute("SELECT coords FROM " .. gangtable .. "HERE id = @id", {['id'] = 1}, function(result)
    if result[1] ~= nil then
      local gcoords = result[1].coords
      if gcoords ~= nil then
        TriggerClientEvent("gang:setcoords",-1,gcoords,gangType)
      end
    else
      -- enter default coords
    end
  end)
end

function updateHotSpotPrices()

  if notDone then
    RandomizeHotSpots()
    notDone = false
  end

  if startTime + (6000) < os.time() then
    notDone = true
  end

  TriggerClientEvent("drugs:hotSpots",-1,hotSpots)
  TriggerEvent("np:news:setHotSpots", hotSpots)
  SetTimeout(300000, updateHotSpotPrices)

end

exports("GetHotSpots", function ()
  return hotSpots
end)
SetTimeout(1000, updateHotSpotPrices)

RegisterServerEvent('gang:updatecoords')
AddEventHandler('gang:updatecoords', function(gangType,newCoords)
  local src = source
  local user = exports["np-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  local cid = tonumber(char.id)
  local usercash = user:getCash()

  if gangType > 0 and usercash > 5000 then
    updateCoords(gangType,newCoords)
    user:removeMoney(5000)
  end

end)

function CompleteUpdate (currentFunds)
  currentFunds = tonumber(currentFunds)
  exports.ghmattimysql:execute("UPDATE general_variables SET value = @value WHERE id = @name", {['value'] = currentFunds, ['name'] = 3})
end

RegisterServerEvent('updatecoordsweed')
AddEventHandler('updatecoordsweed', function(gangType,newCoords)
  exports.ghmattimysql:execute("UPDATE weed_farming SET coords = @newCoords WHERE id = @id", {['newCoords'] = newCoords,['id'] = 1})
  TriggerClientEvent("gang:setcoords",-1,newCoords,gangType)
end)

-- guns meth launder weed
-- gunrunner_farming meth_farming launder_farming weed_farming
function updateCoords(gangType,newCoords)
  src = tonumber(src)
  gangType = tonumber(gangType)
  if gangType == 1 then
    gangtable = "gunrunner_farming"
  elseif gangType == 2 then
    gangtable = "cocaine_farming"
  elseif gangType == 3 then
    gangtable = "launder_farming"
  end
  exports.ghmattimysql.execute("UPDATE" .. gangtable .. " SET coords = @newCoords WHERE id = @id",{['newCoords'] = newCoords,['id'] = 1})
  TriggerClientEvent("gang:setcoords",-1,newCoords,gangType)

end

function updateMayorId()
  exports.ghmattimysql:execute("SELECT value FROM general_variables WHERE id = @id", {['id'] = 2}, function(result)
    mayorid = result[1].value
  end)
end

function updateCurrentTax()
  exports.ghmattimysql:execute("SELECT value FROM general_variables WHERE id = @id", {['id'] = 4}, function(result)
    mayortax = result[1].value
  end)
end



function AddFunds()
  if FundsToAdd ~= 0 then

    exports.ghmattimysql:execute("SELECT value FROM general_variables WHERE id = @id", {['id'] = 3}, function(result)

      currentFunds = tonumber(result[1].value) + tonumber(FundsToAdd)
      currentFunds = math.ceil(currentFunds)
      FundsToAdd = 0

      CompleteUpdate(currentFunds)

    end)
  end
  SetTimeout(600000, AddFunds)
end

RegisterServerEvent('group:pullinformation')
AddEventHandler('group:pullinformation', function(groupid,rank)
  local src = source
  exports.ghmattimysql:execute("SELECT * FROM character_passes WHERE pass_type = @groupid and rank > 0 ORDER BY rank DESC", {['groupid'] = groupid}, function(results)
    if results ~= nil then
      exports.ghmattimysql:execute("SELECT bank FROM group_banking WHERE group_type = @groupid", {['groupid'] = groupid}, function(result)
        local bank = 0
        if result[1] ~= nil then
         bank = result[1].bank
        end
        TriggerClientEvent("group:fullList",src,results,bank,groupid)
      end)
    else
      TriggerClientEvent("phone:error",src)
   end
  end)
end)


passnames = {
  ["gym"] = "LS Gym",
  ["golf"] = "Golf Course",
  ["strip_club"] = "Vanilla Unicorn",
  ["illegal_carshop"] = "Camel Tows",
  ["winery_factory"] = "Delmar & Caine",
  ["carpet_factory"] = "Carpet Company",
  ["casino"] = "Los Santos Casino",
  ["real_estate"] = "Los Santos Real Estate",
  ["weed_factory"] = "The Greenery",
  ["chop_shop"] = "Choppers",
  ["part_shop"] = "Parts Shop",
  ["recycle_shop"] = "Recycle Centre",
  ["car_shop"] = "Car Shop",
  ["repairs_harmony"] = "Harmony Repairs",
  ["tuner_carshop"] = "Tuner Carshop",
  ["dock_worker"] = "Dock Worker",
  ["lost_mc"] = "The Lost MC",
  ["ug_racing"] = "Underground Racing",
  ["hoa"] = "Home Owners Assoc.",
  ["rooster_academy"] = "The Rooster Academy",
  ["sahara_int"] = "Sahara Internationoal",
  ["drift_school"] = "Overboost Drift",
}

-- here we wipe the weed group and start over.

RegisterServerEvent('server:givepayJob')
AddEventHandler('server:givepayJob', function(pJob, pAmount, pSource)
  local src = pSource
  local user = exports["np-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  local cid = tonumber(char.id)
  exports.ghmattimysql:execute("SELECT id,paycheck FROM characters WHERE id = @id", {['id'] = cid}, function(result)
    if result[1] ~= nil then
      local curPaycheck = result[1].paycheck
      TriggerClientEvent("DoLongHudText",src,"A payslip of $"..pAmount.." making a total of $"..tonumber(curPaycheck).." with $"..(math.floor(tonumber(curPaycheck) / 15)).." tax withheld on your last payment.")
    end
  end)

  exports.ghmattimysql:execute("UPDATE characters SET paycheck = paycheck + @amount WHERE id = @cid",
   {
     ['cid'] = cid,
     ['amount'] = pAmount
   }
  )
end)

RegisterServerEvent('server:paySlipPickup')
AddEventHandler('server:paySlipPickup', function()
  local src = source
  local user = exports["np-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  local cid = char.id

  print('this is cid ', cid)

  exports.ghmattimysql:execute("SELECT id,paycheck FROM characters WHERE id = @id", {['id'] = cid}, function(result)
    if result[1] ~= nil then
      local curPaycheck = result[1].paycheck
      if curPaycheck > 0 then
        exports.ghmattimysql:execute("UPDATE characters SET paycheck = 0 WHERE id  = @id", { ['id'] = cid})
        -- local targetAccountId = exports["banking"]:getBankAccount(cid, true)
        -- exports["banking"]:doPersonalTransaction(cid, 1, targetAccountId, curPaycheck, "Payslip")
        print('this is paycheck ', curPaycheck)
        user:addBank(curPaycheck)
        TriggerClientEvent("DoLongHudText",src,"Your payslip of $" .. curPaycheck .. " has been transferred to your bank account",1)
      else
        TriggerClientEvent("DoLongHudText",src,"The cashier stares at you awkardly and says, 'You have no payslip?'",2)
      end
    end
  end)
end)


RegisterServerEvent('server:givepass')
AddEventHandler('server:givepass', function(pass_type, wrank, cid)
  local src = source
  local user = exports["np-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  exports.ghmattimysql:execute("SELECT * FROM characters WHERE id = @id", {['id'] = cid}, function(data)
    exports.ghmattimysql:execute("SELECT * FROM character_passes WHERE id = @id", {['id'] = cid}, function(result)
        if result[1] ~= nil then
          exports.ghmattimysql:execute("UPDATE character_passes SET `rank` = @rank, `giver` = @giver WHERE cid  = @id", { ['id'] = cid, ['rank'] = wrank, ['giver'] = char.first_name .. ' ' .. char.last_name})
        else
          -- TriggerClientEvent('DoShortHudText', src, 'Person is not in your group', 2)
          exports.ghmattimysql:execute("INSERT INTO character_passes(cid, rank, name, giver, pass_type, business_name) values (@id, @rank, @name, @giver, @gang_id, @business_name)",
          {
              ['id'] = cid,
              ['rank'] = wrank,
              ['name'] = data[1].first_name .. ' ' .. data[1].last_name,
              ['giver'] = char.first_name .. ' ' .. char.last_name,
              ['gang_id'] = pass_type,
              ['business_name'] = pass_type
          })
          print('lol kekw ', nam)
        end
    end)
  end)
end)


RegisterServerEvent('server:givepayGroup')
AddEventHandler('server:givepayGroup', function(groupname, amount, cid)
  local src = source
  local user = exports["np-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  exports.ghmattimysql:execute("SELECT * FROM group_banking WHERE group_type = @id", {['id'] = groupname}, function(data)
    if data[1].bank >= tonumber(amount) then
        exports.ghmattimysql:execute("SELECT * FROM character_passes WHERE cid = @id", {['id'] = cid}, function(fuck)
          if fuck[1] ~= nil then
            exports.ghmattimysql:execute("SELECT * FROM characters WHERE id = @id", {['id'] = cid}, function(result)
              local solution = result[1].paycheck + tonumber(amount)
              local solution2 = data[1].bank - tonumber(amount)
              exports.ghmattimysql:execute("UPDATE characters SET `paycheck` = @paycheck WHERE id = @id", { ['id'] = cid, ['paycheck'] = solution})
              exports.ghmattimysql:execute("UPDATE group_banking SET `bank` = @bank WHERE group_type = @group_type", { ['group_type'] = groupname, ['bank'] = solution2})
            end)
          end
        end)
    else
      TriggerClientEvent('DoLongHudText', src, 'You do not have enough money in your account to perform this transaction', 2)
    end
  end)
end)

RegisterServerEvent('server:gankGroup')
AddEventHandler('server:gankGroup', function(groupid, amount)
  local src = source
  local user = exports["np-base"]:getModule("Player"):GetUser(src)
  print('kekw im ehre')
  if user:getCash() >= tonumber(amount) then
    print('good here')
    user:removeMoney(tonumber(amount))
      exports.ghmattimysql:execute("SELECT * FROM group_banking WHERE group_type = @id", {['id'] = groupid}, function(result)
        local solution = result[1].bank + amount
        exports.ghmattimysql:execute("UPDATE group_banking SET `bank` = @bank WHERE `group_type` = @id", { ['id'] = groupid, ['bank'] = solution})
      end)
  end
end)

RegisterServerEvent('setPolicePay')
AddEventHandler('setPolicePay', function(newPay)
  local src = source

  local user = exports["np-base"]:getModule("Player"):GetUser(src)
  if not user then return end
  
  if not user:getVar("mayor") then
    DropPlayer(src, "")
  end

  local payRate = tonumber(payRate)

  if payRate > 200 or payRate < 0 then
    return
  end

  exports.ghmattimysql:execute("UPDATE general_variables SET value = @value WHERE id = @name",{['value'] = newPay, ['name'] = 7})
  TriggerEvent("updateSinglePlays",payRate,'police')
end)

RegisterServerEvent('setEmsPay')
AddEventHandler('setPolicePay', function(newPay)
  local src = source

  local user = exports["np-base"]:getModule("Player"):GetUser(src)
  if not user then return end
  
  if not user:getVar("mayor") then
    DropPlayer(src, "")
  end

  local payRate = tonumber(payRate)

  if payRate > 200 or payRate < 0 then
    return
  end

  exports.ghmattimysql:execute("UPDATE general_variables SET value = @value WHERE id = @name",{['value'] = newPay, ['name'] = 7})
  TriggerEvent("updateSinglePlays",payRate,'ems')
end)

RegisterServerEvent('setCivilianPay')
AddEventHandler('setPolicePay', function(newPay)
  local src = source

  local user = exports["np-base"]:getModule("Player"):GetUser(src)
  if not user then return end
  
  if not user:getVar("mayor") then
    DropPlayer(src, "")
  end

  local payRate = tonumber(payRate)

  if payRate > 100 or payRate < 0 then
    return
  end

  exports.ghmattimysql:execute("UPDATE general_variables SET value = @value WHERE id = @name",{['value'] = newPay, ['name'] = 7})
  TriggerEvent("updateSinglePlays",payRate,'civilian')
end)

function setValue(amount)

  if amount >= 0 and amount <= 45000 then
    return 7
  elseif amount >= 45000 and amount <= 100000 then
    return 20
  elseif amount >= 100000 and amount <= 250000 then
    return 30
  elseif amount >= 250000 and amount <= 500000 then
    return 40
  elseif amount >= 500000 and amount <= 750000 then
    return 50
  elseif amount >= 750000 and amount <= 999999 then
    return 60
  else
    return 70
  end

end

RegisterServerEvent('checkTypes')
AddEventHandler('checkTypes', function()
  local src = source
  local user = exports["np-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  local cid = tonumber(char.id)
  local mayorid = tonumber(mayorid)
  --user:setTax(tonumber(mayortax))

  local myname = char.first_name .. "  " .. char.last_name

  TriggerEvent("garages:loginKeyRequest",src)

  TriggerClientEvent("updateNameClient",src,char.first_name,char.last_name, char.phone_number)

  TriggerClientEvent("updatecid",src,cid)

  TriggerEvent("stocks:update")

  TriggerClientEvent("setTax", src, 15)

  if cid == mayorid then
    user:setVar("mayor", true)
      TriggerClientEvent("setMayor", src)
      TriggerClientEvent("DoLongHudText",-1,"The mayor has joined the city! " .. myname,1)
    end

  TriggerEvent("phone:activeNumber",src,true)
  
  local judgeType = user:getJudgeType()
  local stresslevel = user:getStressLevel()

  TriggerClientEvent("client:updateStress",source,tonumber(stresslevel))
  judgeType = tonumber(judgeType)
    if judgeType ~= 0 then
      TriggerClientEvent("isJudge",src)
      Wait(1000)
      TriggerEvent("isJudge",src)
    end
  end)


--   exports.ghmattimysql:execute("SELECT rank FROM jobs_whitelist WHERE job = @job AND cid = @cid", {['job'] = "therapist", ["cid"] = cid}, function(result2)
--     if(result2 ~= nil and result2[1] ~= nil) then
--       if result2[1].rank >= 1 then
--         TriggerClientEvent("isTherapist",src)
--         Wait(1000)
--         TriggerEvent("isTherapist",src)
--       end
--     end
--   end)

--   TriggerEvent("gang:reputationStart",src,cid)
-- end)

RegisterServerEvent('server:alterStress')
AddEventHandler('server:alterStress', function(positive,alteredValue)
  local src = source
  local user = exports["np-base"]:getModule("Player"):GetUser(source)
  local stresslevel = user:getStressLevel()
  if positive then
    stresslevel = stresslevel + alteredValue
  else
    stresslevel = stresslevel - alteredValue
  end
    if stresslevel > 10000 then
      stresslevel = 10000
    end
      if stresslevel < 0 then
        stresslevel = 0
      end
  user:alterStressLevel(stresslevel)
  TriggerClientEvent("client:updateStress",src,stresslevel)
end)


  

RegisterServerEvent('gang:allowAccess')
AddEventHandler('gang:allowAccess', function(gangType)
  local src = source
  local user = exports["np-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  local cid = tonumber(char.id)

  if gangType > 0 then
    gangCoords(gangType,src)
  end

  TriggerClientEvent('enablegangmember',src,gangType,cid)
end)

RegisterServerEvent('server:currentpassestgt')
AddEventHandler('server:currentpassestgt', function(tgt)
  local src = tonumber(tgt)
  local user = exports["np-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()

  exports.ghmattimysql:execute("SELECT * FROM character_passes WHERE cid = @cid", {['cid'] = char.id}, function(result)
    if result[1] ~= nil then
      TriggerClientEvent("client:passes",src,result)
    else
      TriggerClientEvent("client:passes",src,{})
    end
  end)
end)

RegisterServerEvent('updatePasses')
AddEventHandler('updatePasses', function()

  local src = source
  local user = exports["np-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  local cid = tonumber(char.id)
  local mayorid = tonumber(mayorid)
  -- user:setTax(tonumber(mayortax))

  local myname = char.first_name .. "  " .. char.last_name

  TriggerClientEvent("updatecid",src,cid)

  TriggerEvent("server:currentpassesgt",src)

  exports.ghmattimysql:execute("SELECT * FROM character_passes WHERE cid = @cid", {['cid'] = char.id}, function(result)
    if result[1] ~= nil then
      print('result found')
      TriggerClientEvent("client:passes",src,result)
    else
      TriggerClientEvent("client:passes",src,{})
    end
  end)
end)


RegisterServerEvent('server:currentpasses')
AddEventHandler('server:currentpasses', function(passType)
  local src = source
  local user = exports["np-base"]:getModule("Player"):GetUser(src)
  local char = user:getCurrentCharacter()
  

  exports.ghmattimysql:execute("SELECT * FROM character_passes WHERE cid = @cid", {['cid'] = char.id}, function(result)
    if result[1] ~= nil then
      TriggerClientEvent("client:passes",src,result)
    else
      TriggerClientEvent("client:passes",src,{})
    end
  end)
end)

RegisterServerEvent('checkmayorname')
AddEventHandler('checkmayorname', function()
  local src = source
  local mayorname = "None"

  exports.ghmattimysql:execute("SELECT first_name, last_name FROM characters WHERE id = @id", {['id'] = mayorid}, function(result)

    if result[1] ~= nil then
      blah = result[1].first_name
      dicks = result[1].last_name
      TriggerClientEvent("DoLongHudText",src,"The Mayor is " .. blah .. " " .. dicks,1)
    else
      TriggerClientEvent("DoLongHudText",src,"The Mayor is " .. mayorname,1)
    end

  end)

end)

RegisterServerEvent('server:PayStoreOwner')
AddEventHandler('server:PayStoreOwner', function(cid,cashamount)
  local job = "Player Store Owner"

  exports.ghmattimysql:execute("SELECT id,paycheck FROM characters WHERE id = @cid", {['cid'] = cid}, function(result)
    if result[1] ~= nil then
      local curPaycheck = result[1].paycheck
      local taxWithheld = (cashamount * (mayortax / 100))
      curPaycheck = curPaycheck + (cashamount - (taxWithheld))
      exports.ghmattimysql:execute("UPDATE characters SET paycheck = @curPayCheck WHERE id = @cid",{['cid'] = cid,['curPayCheck'] = curPaycheck})
      TriggerEvent('votesystem:addfunds' ,taxWithheld)
      exports["np-log"]:AddLog("Job Payment", cid, "Amount " .. torstring(cashamount), {cid = cid, cashamount = cashamount, job = job})
    end
  end)
end)

RegisterServerEvent('server:GroupPayment')
AddEventHandler('server:GroupPayment', function( gangid, cashamount, sauce)
  local src = sauce

  if sauce == nil then
    src = source
  end
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
    local cid = tonumber(char.id)

    exports.ghmattimysql:execute("SELECT bank FROM group_banking WHERE group_type = @gangid", {['gangid'] = gangid}, function(result)

      if result[1] ~= nil then

        local curbank = result[1].bank
        curbank = curbank + cashamount
        exports.ghmattimysql:execute("UPDATE group_banking SET bank = @bank WHERE group_type = @gangid", { ['gangid'] = gangid, ['bank'] = curbank})

        exports["np-log"]:AddLog("Group Payment", user, "Amount " .. tostring(cashamount), {cid = cid, cashamount = cashamount, groupid = gangid})
      end
    end)
  end)



function doNewValueCheck()
  exports.ghmattimysql:execute("SELECT name,paid_funds,money,paid_funds FROM user_appartements", {}, function(result)
    for i = 1, #result do 
      local name = result[i].name
      local payment = (tonumber(result[i].paid_funds)) + (tonumber(result[i].money))
      local valuecheck = setValue(tonumber(result[i].paid_funds))
      -- mysql update
   end
  end)
end

RegisterServerEvent('lastconviction')
AddEventHandler('lastconviction', function(newconv)
  recentconvictions[#recentconvictions+1] = newconv
  TriggerClientEvent("lastconvictionlist",-1,recentconvictions)
end)

RegisterServerEvent('currentconvictions')
AddEventHandler('currentconvictions', function(newconv)
  TriggerClientEvent("lastconvictionlist",-1,recentconvictions)
end)

AddEventHandler("np-base:exportsReady", function()
  local commands = exports["np-base"]:getModule("Commands")
  commands:AddCommand("/mayorvote", "Vote in the upcoming election with the player ShowID number(not above head number)", -1, function(src, args)
    --TriggerEvent("votesystem:addvoter", src, args[1])
  end)
end)
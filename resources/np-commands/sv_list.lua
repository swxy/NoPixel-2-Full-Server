local ALL = {F = true}
local EMS = {E = true}
local NEMS = {P = true, E = true, NE = true, D = true}
local NEMS_J = {P = true, E = true, NE = true, D = true, J = true}
local NEMS_MinDoctor = {P = true, E = true, NE = true}
local POLICE = {P = true}
local DOCTOR = {D = true}
local EMS_POLICE = {P = true, E = true}
local EMS_Doctor = {E = true, D = true}
local EMS_Doctor_Judge = {E = true, D = true, J = true}
local EMS_Doctor_Judge_Therapist = {E = true, D = true, J = true, TR = true}
local Doctor_Judge = {D = true, J = true}
local EMERGENCY = {P = true, E = true, D = true}
local EMERGENCY_Judge = {P = true, E = true, D = true, J = true}
local JUDGE = {J = true}
local DI = {DI = true}
local DI_JD_PL = {DI = true, J = true, P = true}
local POLICE_Judge = {P = true, J = true}
local TOW = {T = true}



commands = {

    {"/wing", "Toggle Lock for hospital WING", EMERGENCY_Judge, function(src, args)
      TriggerClientEvent('inter:wing', src)
    end},
    
    {"/rt", "Toggle Radio on and off", EMERGENCY, function(src, args)
      TriggerClientEvent('Tokovoip:toggleRadio', src)
    end},
    
    {"/callsign", "Assign yourself a callsign", EMERGENCY, function(src, args)
      if not args[2] then TriggerClientEvent('DoLongHudText', src, 'Enter a CallSign') return end
      if args[3] then TriggerClientEvent('DoLongHudText', src, 'CallSign must be one word') return end
      TriggerClientEvent('police:callsign', src, args[2])
    end},
    
    {"/aicarry", "Carry an AI ped, press E to drop the body!", EMERGENCY, function(src, args)
      TriggerClientEvent('police:carryAI', src)
    end},
    
    {"/airevive", "Revive an AI ped!", EMERGENCY, function(src, args)
      TriggerClientEvent('police:reviveAI', src)
    end},

    {"/revive", "Revive Target", NEMS, function(src, args)
        TriggerClientEvent('revive', src)
    end},

    {"/revive#", "Revive a person with their in game number", NEMS, function(src, args)
        if not args[2] or not tonumber(args[2]) then return end
        if not GetPlayerName(args[2]) then return end
        TriggerClientEvent('reviveFunction', args[2])
    end},

    {"/escort", "Escort", NEMS, function(src)
        TriggerClientEvent('escortPlayer', src)
    end},
    
    {"/vseat", "Throw someone in a vehicle", EMERGENCY, function(src)
        TriggerClientEvent('police:forceEnter', src)
     end},

     {"/heal", "Heal the closest players", EMS_Doctor, function(src)
        TriggerClientEvent('ems:heal', src)
      end},

    {"/jlivery", "Changes vehicle color", JUDGE, function(src, args)
      TriggerClientEvent('police:chatCommand', src, args, 'livery', true, false)
    end},
    
    {"/jtint", "Changes vehicle color", JUDGE, function(src, args)
      TriggerClientEvent('police:chatCommand', src, args, 'tint', true, false)
    end},
    
    {"/jextra", "Changes vehicle color", JUDGE, function(src, args)
      TriggerClientEvent('police:chatCommand', src, args, 'extra', true, false)
    end},
    
    {"/jcolor", "Changes vehicle color", JUDGE, function(src, args)
      TriggerClientEvent('police:chatCommand', src, args, 'color', true, false)
    end},
    
    {"/jcolor2", "Changes vehicle color", JUDGE, function(src, args)
      TriggerClientEvent('police:chatCommand', src, args, 'color2', true, false)
    end},
    
    {"/aicod", "Gt the cause of injuries to a Ped!", EMERGENCY, function(src, args)
      TriggerClientEvent('police:COD', src)
    end},
    
    {"/whitelist", "Whitelist character ID's (/whitelist job CharID)", EMERGENCY_Judge, function(src, args)
      TriggerClientEvent('police:chatCommand', src, args, 'whitelist', false, false)
    end},
    
    {"/remove", "Remove character ID's whitelist (/remove job CharID)", EMERGENCY_Judge, function(src, args)
      TriggerClientEvent('police:chatCommand', src, args, 'remove', false, fals)
    end},
    
    {"/jail", "/jail [player id] [length]", POLICE_Judge, function(src, args)
      TriggerClientEvent('police:jailCommand', src, args)
    end},
    
    {"/jailalter", "/jailalter [#] [add or remove] [length]", POLICE_Judge, function(src, args)
      TriggerClientEvent('police:jailCommand', src,args)
    end},
    
    {"/racestart", "/race [amount(number or pinkslip)] [custom(true or false)]", ALL, function(src, args)
      if not args[2] then return end
      if not tonumber(args[3]) then return end
      TriggerClientEvent('race:requestStart', src, args[2], args[3])
    end},
    
    {"/cpr", "Pay grandma to help apply CPR!", POLICE, function(src, args)
      TriggerClientEvent('pixerium:check', src, 3, 'trycpr', false)
    end},
    
    {"/forceap", "/forceAp CID ROOMBUMBER LEVEL", POLICE_Judge, function(src, args)
      if not args[2] or not tonumber(args[2]) then return end
      TriggerClientEvent('hotel:forceEntry', src, args[2], args[3], args[4])
    end},
    
    {"/forcehouse", "/forcehouse - enters the house if owned by a player.", POLICE_Judge, function(src, args)
      TriggerClientEvent('housing:enter', src)
    end},
    
    {"/raid", "/raid will open the current house inventory(doesnt work on apartments).", POLICE,_Judge, function(src, args)
      TriggerClientEvent('housing:raid', src)
    end},
    
    {"/resetai", "ResetAllAiInArea", EMS_POLICE, function(src, args)
      TriggerClientEvent('ai:resetInArea', src)
    end},
    
    {"/fix", "Repairs the vehicle you`re in", EMS, function(src, args)
      TriggerClientEvent('police:chatCommand', src, args, 'fix', true, true)
    end},
    
    {"/fix", "Repairs the vehicle you`re in", POLICE, function(src, args)
      TriggerClientEvent('police:chatCommand', src, args, 'fix', true, false)
    end},
    
    {"/sv", "Spawns a police vehicle", NEMS_MinDoctor, function(src, args)
      TriggerClientEvent('police:chatCommand', src, args, 'sv', false, false)
    end},
    
    {"/breach", "type /breach to attemp kicking in a door!", EMS_Police, function(src, args)
      TriggerClientEvent('breach', src,false)
    end},
    
    {"/sport", "Toggle sport Mode", POLICE, function(src, args)
      TriggerClientEvent('police:sport', src)
    end},
    
    {"/trunkeject", "Eject anybody from the trunk of the vehicle you are in", ALL, function(src, args)
      TriggerClientEvent('ped:releaseTrunkCheck', src)
    end},
    
    {"/trunkkidnap", "Throw someone in the trunk - /trunkeject to remove them!", ALL, function(src, args)
      TriggerClientEvent('ped:forceTrunk', src)
    end},
    
    {"/trunkejectself", "Attempt to remove self from trunk!", ALL, function(src, args)
      TriggerClientEvent('ped:releaseTrunkCheckSelf', src)
    end},
    
    {"/trunkgetin", "Crawl in vehicle trunk!", ALL, function(src, args)
      TriggerClientEvent('ped:forceTrunkSelf')
    end},
    
    {"/confirm", "Used to confirm purchase of house", ALL, function(src, args)
      TriggerClientEvent('housing:confirmed', src)
    end},
    
    {"/notes", "Opens your notepad!", ALL, function(src, args)
      TriggerClientEvent('Notepad:open', src)
    end},
    
    {"/news", "Grab a newspaper!", ALL, function(src, args)
      TriggerClientEvent('NewsStandCheck', src)
    end},
    
    {"/atm", "Open the ATM!", ALL, function(src, args)
      TriggerClientEvent('bank:checkATM', src)
    end},
    
    {"/vm", "Use the extremely overpriced vending machine ($20)", ALL, function(src, args)
      TriggerClientEvent('shop:useVM', src)
    end},
    
    {"/bed", "Jump in a hospital bed,", ALL, function(src, args)
      TriggerClientEvent('client:bed', src)
    end},
    
    {"/anchor", "Toggles Anchor for boat", ALL, function(src, args)
      TriggerClientEvent('client:anchor', src)
    end},
    
    {"/taskend", "Decline or end a current email task", ALL, function(src, args)
      TriggerClientEvent('secondaryjob:endtask', src)
    end},
    
    {"/call", "/call 4151231211", ALL, function(src, args)
      if not args[2] or not tonumber(args[2]) then return end
      TriggerClientEvent('phone:makecall', src,args[2])
    end},
    
    {"/payphone", "Use Payphone(anonymous) to call /payphone 4131231231", ALL, function(src, args)
      if not args[2] or not tonumber(args[2]) then return end
      TriggerClientEvent('phone:makepayphonecall', src,args[2])
    end},
    
    {"/finance", "type /finance to enable financing on this car for 30 seconds", ALL, function(src, args)
      TriggerClientEvent('finance', src)
    end},
    
    {"/rentshop", "/rentshop cid propertyname", ALL, function(src, args)
      if not args[2] or not tonumber(args[2]) then return end
      if not args[3] then return end
    
      local namearray = args
      local name = ""
      for i = 3, #namearray do
        name = name .. " " .. namearray[i]
      end
    
      TriggerClientEvent('housing:smallshop', src, args[2], name)
    end},
    
    {"/debug", "Toggle debug for code god mens", ALL, function(src, args)
      TriggerClientEvent('server:enablehuddebug', src)
    end},
    
    {"/ganglock", "Toggle lock on gang house", ALL, function(src, args)
      TriggerClientEvent('gangs:lockhouse', src, 1, false)
    end},
    
    {"/roll", "/roll TIMES MAXCOUNT - ex /roll 3 6 to roll 3 dice up to 6 count", ALL, function(src, args)
      if not args[2] or not tonumber(args[2]) then return end
      if not args[3] or not tonumber(args[3]) then return end
    
      TriggerClientEvent('roll', src, args[2], args[3])
    end},
    
    {"/h1", "Put on your Hat", ALL, function(src, args)
      TriggerClientEvent('facewear:adjust', src, -1, false)
    end},
    
    {"/h0", "Take of your Hat", ALL, function(src, args)
      TriggerClientEvent('facewear:adjust', src, 1, true)
    end},
    
    {"/e1", "Put on your Ear Picees", ALL, function(src, args)
      TriggerClientEvent('facewear:adjust', src, -3, false)
    end},
    
    {"/e0", "Take of your Ear Picees", ALL, function(src, args)
      TriggerClientEvent('facewear:adjust', src, 3, true)
    end},
    
    {"/m1", "Put on your Mask", ALL, function(src, args)
      TriggerClientEvent('facewear:adjust', src, 4, false)
    end},
    
    {"/m0", "Take off your Mask", ALL, function(src, args)
      TriggerClientEvent('facewear:adjust', src, -4, true)
    end},
    
    {"/g1", "Put on your Glasses", ALL, function(src, args)
      TriggerClientEvent('facewear:adjust', src, 2, false)
    end},
    
    {"/g0", "Take off your Glasses", ALL, function(src, args)
      TriggerClientEvent('facewear:adjust', src, -2, true)
    end},
    
    {"/v1", "Put on your vest", ALL, function(src, args)
      TriggerClientEvent('facewear:adjust', src, 5, true)
    end},
    
    {"/v0", "Take off your vest", ALL, function(src, args)
      TriggerClientEvent('facewear:adjust', src, -5, false)
    end},
    
    {"/shoes", "Take their shoes", ALL, function(src, args)
      TriggerClientEvent('facewear:adjust', src, 6, true)
    end},
    
    {"/storecash", "Store Cash In Hotel Room", ALL, function(src, args)
      if not args[2] or not tonumber(args[2]) then return end
      TriggerClientEvent('hotel:AddCashToHotel', src, args[2])
    end},
    
    {"/sellveh", "Sell Vehicle to player (/sellveh <Price> <Plate> <Player>)", ALL, function(src, args)
      if not args[2] or not tonumber(args[2]) then return end
      if not args[3] then return end
      if not args[4] or not tonumber(args[4]) then return end
    
      local target = args[4]
      if not GetPlayerName(target) then
        TriggerClientEvent('DoLongHudText', 'That player does not exist, use the number above their head.',2)
        return
      end
    
      TriggerClientEvent('garages:SellToPlayer', src, args[2], args[3], args[4])
    end},
    
    {"/takecash", "Remove Cash in Hotel Room", ALL, function(src, args)
      if not args[2] or not tonumber(args[2]) then return end
      TriggerClientEvent('hotel:RemoveCashFromHotel', src, args[2])
    end},

    {"/help", "Shows commands list", POLICE, function(src, args)
      TriggerClientEvent('pixerium:check', src, 3, 'trycpr', false)
    end},

    {"/help", "Shows commands list", POLICE, function(src, args)
      TriggerClientEvent('commands:help', src)
    end},

    {"/door1", "Toggle's door number 1", ALL, function(src, args)
      TriggerClientEvent('car:doors', src, "open", 0)
    end},

    {"/door2", "Toggle's door number 2", ALL, function(src, args)
      TriggerClientEvent('car:doors', src, "open", 1)
    end},

    {"/door3", "Toggle's door number 3", ALL, function(src, args)
      TriggerClientEvent('car:doors', src, "open", 2)
    end},

    
    {"/door4", "Toggle's door number 4", ALL, function(src, args)
      TriggerClientEvent('car:doors', src, "open", 3)
    end},

    {"/hood", "Toggle's hood", ALL, function(src, args)
      TriggerClientEvent('car:doors', src, "open", 4)
    end},

    
    {"/trunk", "Toggle's hood", ALL, function(src, args)
      TriggerClientEvent('ped:forceTrunkSelf', src)
    end},

    {"/cpr", "Toggle's hood", ALL, function(src, args)
      TriggerClientEvent('client:cpr', src)
    end},

    {"/use", "idk that", ALL, function(src, args)
      TriggerClientEvent('idk', src)
    end},

    {"/inv", "Shows inventory", ALL, function(src, args)
      TriggerClientEvent('OpenInv', src)
    end},

    {"/phone", "Shows inventory", ALL, function(src, args)
      TriggerClientEvent('phoneGui2', src)
    end},

    {"/e", "Play emote you specified", ALL, function(src, args)
      TriggerClientEvent('animation:PlayAnimation', src, args[1]) 
    end},

    {"/emote", "Play emote you specified", ALL, function(src, args)
      TriggerClientEvent('animation:PlayAnimation', src, args[1]) 
    end},

    {"/emotes", "Toggle's emotes list", ALL, function(src, args)
      TriggerClientEvent('emotes:OpenMenu', src) 
    end},

    {"/as", "idk that", ALL, function(src, args)
      TriggerClientEvent('idk also', src) 
    end},

    {"/selfie", "Toggle's selfie cam on", ALL, function(src, args)
      TriggerClientEvent('selfiePhone', src) 
    end},

    {"/selfie", "Toggle's selfie cam on", ALL, function(src, args)
      TriggerClientEvent('selfiePhone', src) 
    end},

    {"/showid", "Show your ID card", ALL, function(src, args)
      TriggerClientEvent('showID', src) 
    end},

    {"/givekeys", "Give vehicle keys to nearest person.", ALL, function(src, args)
      TriggerClientEvent('keys:give', src) 
    end},

    {"/runplate", "Check for the plate.", ALL, function(src, args)
      TriggerClientEvent('clientcheckLicensePlate', src) 
    end},

    {"/runplatet", "Check for the plate.", ALL, function(src, args)
      TriggerClientEvent('clientcheckLicensePlate', src) 
    end},

    {"/window", "/window open 0-3 or /window close 0-3", ALL, function(src, args)
      TriggerClientEvent('car:windows', src, args[2], args[3]) 
    end},

    {"/rollup", "Rolls up the closest window", ALL, function(src, args)
      TriggerClientEvent('car:windowsup', src) 
    end},

    {"/ooc", "Type /ooc <your message> only use this if very needed!", ALL, function(src, args)
      if not args[2] then return end
      local msg = ""
      for i = 2, #args do
        msg = msg .. " " .. args[i]
      end
      local user = exports["np-base"]:getModule("Player"):GetUser(src)
      local char = user:getCurrentCharacter()
      local name = char.first_name .. " " .. char.last_name
      TriggerClientEvent( "chatMessage",-1 , "OOC " .. name .. " [".. src .. "]", 2 , msg)
      exports["np-log"]:AddLog("OOC Chat [".. src .."]", user, name .. ": " .. msg, {})
    end},
    
    }

    RegisterCommand('sport', function(source, args)
      local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)

      if user:getVar("job") == 'police' then
        TriggerClientEvent('police:sport', src)
  end
end)
local weapons = ""
local playerInjury = {}
local bones = {}
local multipledenominators = {}

local firstname = {
    'Mona',
    'Ray',
    'Sonny',
    'Don',
    'Jo',
    'Joe',
    'Dixon',
    'Ben',
    'Hugh G.',
    'Duncan',
    'Mike',
    'Mike',
    'Mike',
    'Ima',
    'Richard'
}

local lastname = {
    'Alott',
    'Gunn',
    'Day',
    'Key',
    'King',
    'Kane',
    'Uranus',
    'Dover',
    'Rection',
    'McOkiner',
    'Hawk',
    'Hunt',
    'Oxlong',
    'Pigg',
    'Head'
}

local logged = {}

RegisterServerEvent('server:takephone')
AddEventHandler('server:takephone', function(target)
    TriggerClientEvent('inventory:removeItem', target, "mobilephone", 1)
end)

RegisterServerEvent('police:multipledenominators')
AddEventHandler('police:multipledenominators', function(hasdenoms)
	local src = source
	if hasdenoms then
		multipledenominators[src] = true
	else
		multipledenominators[src] = nil
	end
end)

RegisterServerEvent('CrashTackle')
AddEventHandler('CrashTackle', function(player)
	TriggerClientEvent('playerTackled', player)
end)

RegisterServerEvent('police:targetCheckBank')
AddEventHandler('police:targetCheckBank', function(target)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(target)
	local char = user:getCurrentCharacter()
	balance = user:getBalance()
  local strng = " Bank: "..balance
  TriggerClientEvent("DoLongHudText",src,strng)
end)


RegisterNetEvent("policeimpound")
AddEventHandler("policeimpound",function()
local src = source
local user = exports["np-base"]:getModule("Player"):GetUser(source)
user:addMoney(100)
end)

RegisterServerEvent('checkLicensePlate')
AddEventHandler('checkLicensePlate', function(oof)
	local source = source
	local user = exports["np-base"]:getModule("Player"):GetUser(source)
	local char = user:getCurrentCharacter()
	local job = "Unemployed"
	local message = ""
	local phonenumber = char.phone_number
	local kekw = oof
        exports.ghmattimysql:execute('SELECT * FROM characters_cars WHERE `license_plate` = @plate', { ['@plate'] = kekw }, function(result)
        	if result[1] ~= nil then
				exports.ghmattimysql:execute('SELECT * FROM characters WHERE `id` = @cid', { ['@cid'] = result[1].cid }, function(data)
					exports.ghmattimysql:execute('SELECT * FROM jobs_whitelist WHERE `owner` = @cid', { ['@cid'] = data[1].id }, function(penis)
					-- TriggerClientEvent('notification', source, 'Dispatch: Vehicle comes back to one ' .. data[1].firstname .. ' ' .. data[1].lastname .. ' Over.')
						if penis[1] ~= nil then
							job = penis[1].job
							if job == "police" then
								job = "Police"
							elseif job == "ems" then
								job = "EMS"
							end
							local phoneNumber = string.sub(data[1].phone_number, 0, 3) .. '-' .. string.sub(data[1].phone_number, 4, 6) .. '-' .. string.sub(data[1].phone_number, 7, 10)
							TriggerClientEvent("chatMessage", source, "DISPATCH", 3, "10-74 (Negative) Name: " .. data[1].first_name .. " " .. data[1].last_name .. " Phone #: " .. phoneNumber .. ' Job: ' .. job)
							TriggerClientEvent('InteractSound_CL:PlayOnOne', source, 'radioclick', 1.0)
						else
							TriggerClientEvent("chatMessage", source, "DISPATCH", 3, "10-74 (Negative) Name: " .. data[1].first_name .. " " .. data[1].last_name .. " Phone #: " .. phoneNumber .. ' Job: Unemployed')
							TriggerClientEvent('InteractSound_CL:PlayOnOne', source, 'radioclick', 1.0)
						end
					end)
				end)
			elseif logged[#logged] ~= nil then
				for k,v in ipairs(logged) do
					if v.plate == kekw then
						TriggerClientEvent("chatMessage", source, "DISPATCH", 3, "10-74 (Negative) Name: " .. v.firstname .. " " .. v.lastname .. " Phone #: " .. math.random(000, 999) .. '-' .. math.random(000, 999) .. '-' .. math.random(0000, 9999) .. ' Job: Unemployed')
					end
				end
			else
				local insert = {
					plate = kekw,
					firstname = firstname[math.random(1,5)],
					lastname = lastname[math.random(1,5)]
				}
				TriggerClientEvent("chatMessage", source, "DISPATCH", 3, "10-74 (Negative) Name: " .. insert.firstname .. " " .. insert.lastname .. " Phone #: " .. math.random(000, 999) .. '-' .. math.random(000, 999) .. '-' .. math.random(0000, 9999) .. ' Job: Unemployed')
				logged[#logged+1] = insert
				print(json.encode(logged))
				TriggerClientEvent('InteractSound_CL:PlayOnOne', source, 'radioclick', 1.0)
	        end
		end)
end)

RegisterServerEvent('dragPlayer:disable')
AddEventHandler('dragPlayer:disable', function()
	TriggerClientEvent('drag:stopped', -1, source)
end)

RegisterServerEvent('dr:releaseEscort')
AddEventHandler('dr:releaseEscort', function(releaseID)
	TriggerClientEvent('dr:releaseEscort', tonumber(releaseID))
end)

RegisterServerEvent('police:IsTargetCuffed') -- that is np's code ((sway))
AddEventHandler('police:IsTargetCuffed', function(playerID)
	local src = source
	TriggerClientEvent("police:IsPlayerCuffed", playerID, src)
end)

-- done ((sway))
function CheckLicense(cid, license)
	exports.ghmattimysql:execute("SELECT @license FROM licenses WHERE cid = @id", {['id'] = cid, ['license'] = license}, function(result)
		if (result[1]) then
			response = result.license
		end
	end)
	Wait(200)
	if response then
		return true
	else
		return false
	end
end

function getmonth(month) -- that is np's code ((sway))
	local months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
	return months[tonumber(month)]
end

function ConvertDate(d) -- that is np's code ((sway))
	local newD = math.ceil(tonumber(d/1000))
	local msgtime = "NA"
	if newD < 0 then
			newD = newD + 4070912400
			local a = os.date("%b %Y", newD)
			msgtime = string.upper(getmonth(a.month) .. " " .. (a.year-129))
	else
		msgtime = os.date("%b &Y", newD)
		msgtime = string.upper(msgtime)
	end
	return msgtime
end


RegisterNetEvent("spawn100k")
AddEventHandler("spawn100k",function ()
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	user:removeMoney(500)
end)

RegisterServerEvent('police:showID')
AddEventHandler('police:showID', function(itemInfo)
	local src = source
	local fuck = json.decode(itemInfo)
	local data = {
		['DOB'] = fuck.DOB,
		['Name'] = fuck.Name,
		['Surname'] = fuck.Surname,
		['Sex'] = fuck.Sex,
		['Identifier'] = fuck.identifier,
		['pref'] = "sex"
	}

	if data.Sex == 0 then
		data = {
			['DOB'] = fuck.DOB,
			['Name'] = fuck.Name,
			['Surname'] = fuck.Surname,
			['Sex'] = "M",
			['Identifier'] = fuck.identifier,
			['pref'] = "Male"
		}
	elseif data.Sex == 1 then
		data = {
			['DOB'] = fuck.DOB,
			['Name'] = fuck.Name,
			['Surname'] = fuck.Surname,
			['Sex'] = "F",
			['Identifier'] = fuck.identifier,
			['pref'] = "Female"
		}
	end
	print(json.encode(data))
	TriggerClientEvent("chat:showCID", -1, data, src)
end)

RegisterServerEvent('gc:showthemIdentity')
AddEventHandler('gc:showthemIdentity', function(user)
	local src = source
	--
end)

RegisterServerEvent('police:showPH') -- that is np's code ((sway))
AddEventHandler('police:showPH', function()
	local src = source
	local player = exports["np-base"]:getModule("Player"):GetUser(src)
	local char = player:getCurrentCharacter()
	local result = {phone_number = char.phone_number}
	TriggerClientEvent('outlawNotifyPhone', -1, src, result)
end)

RegisterServerEvent('police:jailGranted')
AddEventHandler('police:jailGranted', function(args)
	local src = source
	reason = " "
	for argscount = 4, #args do
		reason = reason .. " " .. args[argscount]
	end

	local player = tonumber(args[1])
	local target = exports["np-base"]:getModule("Player"):GetUser(player)
	local character = target:getCurrentCharacter()
	local playerName = character.first_name .. ' ' .. character.last_name

	local pdunit = exports["np-base"]:getModule("Player"):GetUser(src)
	if not pdunit:getVar("job") == "police" then
		local steamid, name = pdunit:getVar("name"), pdunit:getVar("steamid")

		exports["np-log"]:AddLog("Exploiter", pdunit, "User Attempted to jail player while not on pd", {target = playerName, reason = reason, cid = cid, time = tonumber(args[2]), src= src})
		DropPlayer(src, "")

		return
	end

	TriggerClientEvent('chatMessage', src, "JAILED ", 3, "" .. playerName .. " has been put in jail for " .. tonumber(args[2]) .. " month(s) for " .. reason)
	
	TriggerClientEvent('beginJail', player, false,args[2], playerName, character.id, date)
	

	local date = os.date("%c")
	TriggerClientEvent("drawScaleformJail", -1,tonumber(args[2]),playerName,character.id,date)

	TriggerEvent("np:news:newConviction", {name = playerName, duration = time, charges = reason})

	TriggerEvent('server-jail-items', character.id, true)
	exports["np-base"]:getModule("JobManager"):SetJob(target, "unemployed", true)

	--crimeUser(player,reason,character.id)

end)

RegisterServerEvent("police:deletecrimes")
AddEventHandler("police:deletecrimes", function(target)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local identifier = user:getVar("hexid")

	local pdunit = exports["np-base"]:getModule("Player"):GetUser(src)
	if not pdunit:getVar("job" =="police") then
		local steamid, name = pdunit:getVar("name"), pdunit:getVar("steamid")

		exports["np-log"]:AddLog("Exploiter", pdunit, "User Attempted delete crimes while not on duty", {target = target , src = src})
		DropPlayer(src, "")

		return
	end
	
	-- missing here
end)

RegisterServerEvent('police:gsrGranted') -- that is np's code ((sway))
AddEventHandler('police:gsrGranted', function(t)
    local copId = source
    TriggerClientEvent("DoLongHudText", t, 'You have been GSR tested',1)
    TriggerClientEvent('police:hasShotRecently', t, copId)
end)

RegisterServerEvent('police:hasShotRecently') -- that is np's code ((sway))
AddEventHandler('police:hasShotRecently', function(shotRecently, copId)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local character = user:getCurrentCharacter()
	local msg = string.format("%s has returned %s for GSR testing", character.id, shotRecently and "positive" or "negative")
	
    TriggerClientEvent("chatMessage", copId, "", {255,0,0}, msg)
end)

RegisterServerEvent('police:fingerPrintAsk')
AddEventHandler('police:fingerPrintAsk', function(t, v)
	-- 3.0 Code ((sway))
	local src = source
	TriggerClientEvent("DoLongHudText", src, 'Finger Printing..', 1)
	TriggerClientEvent("DoLongHudText", t, 'You have ben Finger Print tested', 1)
	TriggerClientEvent('police:fingerPrintVeh', t, v)
end)

RegisterServerEvent('police:remmaskGranted') -- that is np's code ((sway))
AddEventHandler('police:remmaskGranted', function(targetplayer)
    TriggerClientEvent('police:remmaskAccepted', targetplayer)
end)

RegisterServerEvent('unseatAccepted') -- that is np's code ((sway))
AddEventHandler('unseatAccepted', function(targetplayer,x,y,z)
    TriggerClientEvent('unseatPlayerFinish', targetplayer,x,y,z)
end)

RegisterServerEvent('police:updateLicenses')
AddEventHandler('police:updateLicenses', function(targetlicense, status, license)
    if status == 1 then
		-- add license
	else
		-- remove license
    end
end)

RegisterServerEvent("police:targetCheckInventory")
AddEventHandler("police:targetCheckInventory", function(target, status)
	-- done for npx ((sway))
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(target)
	local char = user:getCurrentCharacter()
	TriggerClientEvent("server-inventory-open", source, "1", "ply-"..char.id)
end)





RegisterServerEvent('police:SeizeCash')
AddEventHandler('police:SeizeCash', function(target)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local characterId = user:getVar("character").id
	local userz = exports["np-base"]:getModule("Player"):GetUser(target)
	if not user.job.name == 'police' then
		print('cid: '..characterId..' User attempted sieze cash')
		return
	end

	local cash = userz:getCash()
	userz:removeMoney(cash)
	user:addMoney(cash)
	TriggerClientEvent('DoLongHudText', target, 'Your cash and Marked Bills was seized',1)
	TriggerClientEvent('DoLongHudText', src, 'Seized persons cash', 1)
end)


--- POLICE SEXTION -------------------------------

RegisterServerEvent('police:cuffGranted2')
AddEventHandler('police:cuffGranted2', function(t,softcuff)
	local src = source
    
	print('cuffing')
	TriggerClientEvent('menu:setCuffState', t, true)
	TriggerEvent('police:setCuffState2', t, true)
	if softcuff then
        TriggerClientEvent('handCuffedWalking', t)
        print('softcuff')
    else
        print('hardcuff')
		TriggerClientEvent('police:getArrested2', t, src)
		TriggerClientEvent('police:cuffTransition',src)
	end
end)

RegisterServerEvent('police:cuffGranted')
AddEventHandler('police:cuffGranted', function(t)
	local src = source
	
		TriggerEvent('police:setCuffState', t, true)
		TriggerClientEvent('menu:setCuffState', t, true)
		TriggerClientEvent('police:getArrested', t, src)
		TriggerClientEvent('police:cuffTransition',src)
end)

RegisterServerEvent('police:escortAsk')
AddEventHandler('police:escortAsk', function(target)
		TriggerClientEvent('dr:escort', target,source)
end)




RegisterServerEvent('falseCuffs')
AddEventHandler('falseCuffs', function(t)
	TriggerClientEvent('falseCuffs',t)
	TriggerClientEvent('menu:setCuffState', t, false)
end)

RegisterServerEvent('police:setCuffState')
AddEventHandler('police:setCuffState', function(t,state)
	TriggerClientEvent('police:currentHandCuffedState',t,true)
	TriggerClientEvent('menu:setCuffState', t, true)
end)




RegisterServerEvent('police:forceEnterAsk')
AddEventHandler('police:forceEnterAsk', function(target,netid)
		TriggerClientEvent('police:forcedEnteringVeh', target, netid)
		TriggerClientEvent('notification', source, 'Seating Player',1)
end)

--- POLICE SEXTION ^^^^^^^^^^^^

function checkDBForDna(ident,dna)
	local canUse = true
	exports.ghmattimysql:execute("SELECT meta FROM characters WHERE id = @identifier", {['identifier'] = ident}, function(result)
		if (result[1]) then
			meta = json.decode(result[1].dna)
			if meta.dna ~= dna then
				canUse = true
			end
		end
	end)
	Wait(200)
	if canUse then
		return true
	else
		return false
	end
end


RegisterServerEvent('ped:forceTrunkAsk')
AddEventHandler('ped:forceTrunkAsk', function(targettrunk)
	TriggerClientEvent('ped:forcedEnteringVeh', targettrunk)
end)

RegisterServerEvent('Evidence:GetWounds')
AddEventHandler('Evidence:GetWounds', function(t)
	print(t)
	TriggerClientEvent('Evidence:GiveWounds',t,source)
end)

RegisterServerEvent('Evidence:GiveWoundsFinish')
AddEventHandler('Evidence:GiveWoundsFinish', function(CurrentDamageList,id,bones)
	local src = source
	TriggerClientEvent('Evidence:CurrentDamageListTarget',id,CurrentDamageList,bones,src)
end)

RegisterServerEvent('evidence:bleeder')
AddEventHandler('evidence:bleeder', function(isBleeding)
	local src = source
	TriggerClientEvent('bleeder:alter',src,isBleeding)
end)

RegisterServerEvent('bones:server:updateServer')
AddEventHandler('bones:server:updateServer', function(bones)
	local src = source

	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local characterId = user:getVar("character").id
	local pastebones = json.encode(bones)
	local bones = json.encode(bones)

	exports.ghmattimysql:execute("UPDATE characters SET `bones` = @bones WHERE id = @identifier", {['bones'] = bones, ['identifier'] = characterId})
end)

RegisterServerEvent("Evidence:checkDna")
AddEventHandler("Evidence:checkDna", function()
		local src = source
		local user = exports["np-base"]:getModule("Player"):GetUser(src)
		local char = user:getVar("character")
		local needsNewDna = false

		exports.ghmattimysql:execute("SELECT dna FROM characters WHERE id = @identifier", {['identifier'] = char.id}, function(result)
			if (result[1]) then
				if(result[1].dna) then
					meta = json.decode(result[1].dna)
					if meta ~= nil then
						if meta.dna == "" then
							needsNewDna = true
						end
					else
					 needsNewDna = true
					end
	     		 else
					needsNewDna = true
		 		end
	   		else
		 		needsNewDna = true
	 	 end
	 end)
	Wait(300)
	if needsNewDna then
	local dna = ""
	local check = false
	while check == false do
		dna = math.random(1000,9999).."-"..math.random(10000,99999).."-"..math.random(0,999)
		Wait(1200)
		check = checkDBForDna(characterId,dna)
	end
	local metaData = {["dna"] = dna, ["health"] = 200, ["armour"] = 0, ["animSet"] = "none"}
	 meta = json.encode(metaData)
	 exports.ghmattimysql:execute("UPDATE characters SET `dna` = @metaData WHERE id = @identifier", {['metaData'] = meta, ['identifier'] = characterId})
	end
end)

RegisterServerEvent('police:setServerMeta')
AddEventHandler('police:setServerMeta', function(health, armor, thrist, hungry)
	print("saving hunger and thirst")
    local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	
	if not user then 
		print(debug.stacktrace)
		return 
	end
	
	local char = user:getVar("character")
	local q = [[UPDATE characters SET metaData = @meta WHERE id = @cid;]]
	local v = {
		["meta"] = json.encode({["health"] = health, ["armour"] = armor, ["thrist"] = thrist, ["hunger"] = hungry}),
		["cid"] = char.id
	}

	if not user then return end
	exports.ghmattimysql:execute(q, v, function()

    end)
end)

RegisterServerEvent('police:SetMeta')
AddEventHandler('police:SetMeta', function()
    local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local cid = user:getCurrentCharacter().id
	local metadata
	exports.ghmattimysql:execute("SELECT metaData FROM characters WHERE id = @cid;", {["cid"] = cid}, function(result)
		if (result[1].metaData) then
			print(json.encode(result[1].metaData))
			metadata = json.decode(result[1].metaData)
			TriggerClientEvent('police:setClientMeta', src, {thirst = metadata.thirst, hunger = metadata.hunger, health = metadata.health, armour = metadata.armour})
		end
    end)
end)

RegisterServerEvent('government:bill')
AddEventHandler('government:bill', function(data)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	user:removeMoney(data)
end)

RegisterServerEvent('sniffAccepted')
AddEventHandler('sniffAccepted', function(data)
	TriggerClientEvent('K9:SniffConfirmed', source)
end)

RegisterServerEvent('reviveGranted')
AddEventHandler('reviveGranted', function(t)
	TriggerClientEvent('reviveFunction', t)
end)

RegisterServerEvent('ems:stomachpumptarget')
AddEventHandler('ems:stomachpumptarget', function(t)
	TriggerClientEvent('fx:stomachpump', t)
end)

RegisterServerEvent('police:emsVehCheck')
AddEventHandler('police:emsVehCheck', function()
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	
	if user:getVar("job") == "ems" or "doctor" then
		TriggerClientEvent('emsGarage:Menu', src, true)
	else
		TriggerClientEvent('DoLongHudText', src, "Fuck off dick head those vehicles belong's to EMS", 2)
	end
end)

RegisterServerEvent('ems:healplayer')
AddEventHandler('ems:healplayer', function(t)
	TriggerClientEvent('ems:healpassed',t)
end)

RegisterServerEvent('huntAccepted')
AddEventHandler('huntAccepted', function(player, distance, coords)
	TriggerClientEvent('K9:HuntAccepted', source)
end)

--[[---------------------------------------------------
						Emotes
--]]---------------------------------------------------

RegisterServerEvent('police:setEmoteData')
AddEventHandler('police:setEmoteData', function(emoteTable)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
	local emote = json.encode(emoteTable)
	exports.ghmattimysql:execute("UPDATE characters SET `emotes` = @emotes WHERE id = @cid", {['emotes'] = emote, ['cid'] = char.id})
end)

RegisterServerEvent('police:setAnimData')
AddEventHandler('police:setAnimData', function(AnimSet)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()
	local metaData = json.encode(AnimSet)
	exports.ghmattimysql:execute("UPDATE characters SET `meta` = @metaData WHERE id = @cid", {['metaData'] = metaData, ['cid'] = char.id})
end)

RegisterServerEvent('police:getAnimData')
AddEventHandler('police:getAnimData', function()
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()

	exports.ghmattimysql:execute("SELECT meta FROM characters WHERE id = @cid", {['cid'] = char.id}, function(result)
		if (result[1]) then
			if not result[1].meta then
				TriggerClientEvent('checkDNA', src)
			else
				local sex = json.decode(result[1].meta)
			if sex == nil then
				TriggerClientEvent('CheckDNA',src)
				return
			end
			TriggerClientEvent('emote:setAnimsFromDB', src, result[1].meta)
			end
		end
	end)
end)

RegisterServerEvent('police:getEmoteData')
AddEventHandler('police:getEmoteData', function()
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
    local char = user:getCurrentCharacter()

	exports.ghmattimysql:execute("SELECT emotes FROM characters WHERE id = @cid", {['cid'] = char.id}, function(result)
		if(result[1]) then
			local emotes = json.decode(result[1].emotes)
			if result[1] ~= nil then
				TriggerClientEvent('emote:setEmotesFromDB', src,emotes)
			else
				local emoteTable = {
					{['key'] = {289},["anim"] = "Handsup"},
					{['key'] = {170},["anim"] = "HandsHead"},
					{['key'] = {166},["anim"] = "Drink"},
					{['key'] = {167},["anim"] = "Lean"},
					{['key'] = {168},["anim"] = "Smoke"},
					{['key'] = {56},["anim"] = "FacePalm"},
					{['key'] = {57},["anim"] = "Wave"},

					{['key'] = {289,21},["anim"] = "gangsign1"},
					{['key'] = {170,21},["anim"] = "gangsign3"},
					{['key'] = {166,21},["anim"] = "gangsign2"},
					{['key'] = {167,21},["anim"] = "hug"},
					{['key'] = {168,21},["anim"] = "Cop"},
					{['key'] = {56,21},["anim"] = "Medic"},
					{['key'] = {57,21},["anim"] = "Notepad"},
				}

				local emote = json.encode(emoteTable)
				exports.ghmattimysql:execute("UPDATE characters SET `emotes` = @emotes WHERE id = @cid", {['emotes'] = emote, ['identifier'] = char.id})
				TriggerClientEvent("emote:setEmotesFromDB", src, emoteTable)
			end
		end
	end)
end)
--[[
 RegisterCommand('testing123', function(source)
 	local src = source
 	local user = exports["np-base"]:getModule("Player"):GetUser(src)
 	user:setRank("dev")
 	print("done knk")
 end)
--]]

RegisterServerEvent('police:whitelist')
AddEventHandler('police:whitelist', function(arg,jobType)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()

	if jobType == "police" or jobType == "ems" or jobType == "doctor" or jobType == "therapist" or jobType == "doc" then
		exports.ghmattimysql:execute("SELECT rank from jobs_whitelist WHERE job = @job AND cid = @cid",{['job'] = jobType, ["cid"] = arg}, function(result)
			if(result[1]) then
				TriggerClientEvent("DoLongHudText", src, 'This person is already on the list.', 2)
			else
				exports["np-log"]:AddLog("HC Added Job","Character: "..char.id.." Changed Char: "..arg.." Job whitelisting: "..jobType.." Type: Added", {source = src, char = char.id})

				exports.ghmattimysql:execute("INSERT INTO jobs_whitelist (owner,cid,job,rank) VALUES (@owner,@cid,@job,@rank)",
				{['owner'] = arg,['cid'] = arg,['job'] = jobType,['rank'] = 1})
				
				TriggerClientEvent("DoLongHudText", src, "Person Added , CID = "..arg.." Job = "..jobType.." Rank 1",1)
			end
		end)
	elseif jobType == "judge" then
		exports.ghmattimysql:execute("SELECT judge_type FROM characters WHERE id = @cid", {["cid"] = char.id}, function(result)
			if result[1] then
				if result[1].judge_type == 10 then
					exports["np-log"]:AddLog("HC Added Job","Character: "..char.id.." Changed Char: "..arg.." Job whitelisting "..jobType.." Type: Added", {source = src,char = char.id})
					exports.ghmattimysql:execute("UPDATE characters SET `judge_type`=@rank WHERE id = @cid", {['rank'] = 1, ["cid"] = arg})
					TriggerClientEvent("DoLongHudText", src, 'Person added , CID = '..arg.." Job = "..jobType.." Rank 1",1)
				else
					TriggerClientEvent("DoLongHudText", src, 'Not high enough rank.',2)
				end
			else
				TriggerClientEvent("DoLongHudText", src, 'Invalid Character ID.',2)
			end
		end)
	else
		TriggerClientEvent("DoLongHudText", src, 'invalid Job.',2)
	end
end)

RegisterServerEvent('police:remove')
AddEventHandler('police:remove', function(arg,jobType)
	local src = source
	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()

	if jobType == "police" or jobType == "ems" or jobType == "doctor" or jobType == "therapist" or jobType == "doc" then
		exports.ghmattimysql:execute("SELECT rank from jobs_whitelist WHERE job = @job AND cid = @cid",{['job'] = jobType, ["cid"] = arg}, function(result)
			if(result[1]) then
				TriggerClientEvent("DoLongHudText", src, 'This person is already on the list.', 2)
			else
				exports["np-log"]:AddLog("HC Removed Job","Character: "..char.id.." Changed Char: "..arg.." Job whitelisting: "..jobType.." Type: Removed", {source = src, char = char.id})

				exports.ghmattimysql:execute("DELETE FROM jobs_whitelist WHERE owner = @owner, cid = @cid, job = @job",
				{['owner'] = arg,['cid'] = arg,['job'] = jobType})
				
				TriggerClientEvent("DoLongHudText", src, "Person Removed , CID = "..arg.." Job = "..jobType,1)
			end
		end)
	elseif jobType == "judge" then
		exports.ghmattimysql:execute("SELECT judge_type FROM characters WHERE id = @cid", {["cid"] = char.id}, function(result)
			if result[1] then
				if result[1].judge_type == 10 then
					exports["np-log"]:AddLog("HC Removed Job","Character: "..char.id.." Changed Char: "..arg.." Job whitelisting "..jobType.." Type: Removed", {source = src,char = char.id})
					exports.ghmattimysql:execute("UPDATE characters SET `judge_type`=@rank WHERE id = @cid", {['rank'] = 0, ["cid"] = arg})
					TriggerClientEvent("DoLongHudText", src, 'Person removed , CID = '..arg.." Job = "..jobType,1)
				else
					TriggerClientEvent("DoLongHudText", src, 'Not high enough rank.',2)
				end
			else
				TriggerClientEvent("DoLongHudText", src, 'Invalid Character ID.',2)
			end
		end)
	else
		TriggerClientEvent("DoLongHudText", src, 'invalid Job.',2)
	end
end)

-- RegisterServerEvent("isVip")
-- AddEventHandler("isVip", function(src)
-- 	local commands = exports["np-base"]:getModule("Commands")
-- 	if src == nil or src == 0 then src = source end

-- 	local user = exports["np-base"]:getModule("Player"):GetUser(src)
-- 	local steamcheck = user:getVar("steamid")

-- 	exports.ghmattimysql:execute("SELECT * FROM vip_list WHERE steamid = @steamcheck",{['steamcheck'] = steamcheck}, function(result)
-- 		if result[1] then
-- 			commands:RemoveCommand("/priority", src)

-- 			commands:AddCommand("/priority", "/priority [check] #pid | [alter] #pid #rank", src, function(src, args)
-- 				local user = exports["np-base"]:getModule("Player"):GetUser(src)

-- 				local char = user:getCurrentCharacter()
-- 					local name = char.first_name .. " " .. char.last_name

-- 				if not args[2] then return end
-- 				if not tonumber(args[1]) then return end
-- 				if args[2] == "alter" and not tonumber(args[4]) then return end

-- 				local target = tonumber(args[1])
-- 				local user = exports["np-base"]:getModule("Player"):GetUser(target)
-- 				local steamcheck = user:getVar("steamid")

-- 				if args[1] == "check" then
-- 					exports.ghmattimysql:execute("SELECT * FROM users_whitelist WHERE steamid = @steamcheck",{['steamcheck'] = steamcheck}, function(result)

-- 						TriggerClientEvent("DoLongHudText",src,"Targets rank was " .. result[1].power)
-- 					end)

-- 				elseif args[2] == "alter" then

-- 					local rank = tonumber(args[4])

-- 					if rank == nil then

-- 						if rank < 1 then
-- 							rank = 0
-- 						end
-- 						exports.ghmattimysql:execute("UPDATE users_whitelist SET 'power'=@rank,'admin_name'=@name WHERE steamid = @steamcheck",{['name'] = name, ['rank'] = rank, ['steamcheck'] = steamcheck})
-- 						if rank == 0 then
-- 							TriggerClientEvent("DoLongHudText",src,steamcheck .. " was unwhitelisted.")
-- 						else
-- 							TriggerClientEvent("DoLongHudText",src,steamcheck .. " set to rank of " .. rank)
-- 						end

-- 					else
-- 						TriggerClientEvent("DoLongHudText",src,"Error - no rank",2)
-- 					end

-- 				end

-- 			end)

-- 		else


-- 			commands:RemoveCommand("/priority", src)

-- 			commands:AddCommand("/priority", "/priority [check] #pid", src, function(src, args)
-- 				local user = exports["np-base"]:getModule("Player"):GetUser(src)

-- 				local char = user:getCurrentCharacter()
-- 					local name = char.first_name .. " " .. char.last_name

-- 				if not args[2] then return end
-- 				if not tonumber(args[3]) then return end

-- 				local target = tonumber(args[1])
-- 				local user = exports["np-base"]:getModule("Player"):GetUser(target)
-- 				local steamcheck = user:getVar("steamid")

-- 				if args[2] == "check" then
-- 					exports.ghmattimysql:execute("SELECT * FROM users_whitelist WHERE steamid = @steamcheck",{['steamcheck'] = steamcheck}, function(result)

-- 						TriggerClientEvent("DoLongHudText",src,"Targets rank was " .. result[1].power)
-- 					end)

-- 				end

-- 			end)

-- 		end

-- 	end)

-- end)

function jailUser(player,reason,cid,time,src)
	local jailer = exports["np-base"]:getModule("Player"):GetUser(src)
	if not jailer then return false end

	if not jailer:getVar("job") == "police" and not jailer:getVar("job") == "doc" then
		local steamid, name = jailer:getVar("name"), jailer:getVar("steamid")

		exports["np-log"]:AddLog("Exploiter", jailer, "User attempted to jail while not on pd; Reason: " ..tostring(reason), {target = player, reason = reason, cid = cid, time = time})
		DropPlayer(src, "")
		return
	end

	local player = tonumber(player)
	local playerName = GetPlayerName(player)
	local target = exports["np-base"]:getModule("Player"):GetUser(player)
	local character = target:getCurrentCharacter()

	--TriggerClientEvent('chatMessage', src, "JAILED", 3, "" .. playerName .. " has been put in jail for " .. tonumber(time) .. " month(s). for " ..reason)

	TriggerClientEvent('beginJail', player,false,time)
	TriggerEvent("np-police:playerJailed", character)

	local date = os.date("%c")
	TriggerClientEvent("drawScaleformJail", -1, time, playerName, character.id, date)
	
		TriggerEvent("np:news:newConviction", {name = playerName, duration = time, charges = reason})

		TriggerEvent("server-jail-items", character.id, true)
		exports["np-base"]:getModule("JobManager"):SetJob(target, "unemployed", true)

		crimeUser(player,reason,character.id)
		
end

RegisterServerEvent("911")
AddEventHandler("911", function(args)
	local src = source

	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()
	local job = user:getVar("job")
	local message = ""

	local phonenumber = char.phone_number

	for k,v in ipairs(args) do
		message = message .. " " .. v
	end
	local caller = tostring(char.first_name) .. " " .. tostring(char.last_name)
	exports["np-log"]:AddLog("911 Chat", user, caller .. ": " .. message, {})

	TriggerClientEvent("GPSTrack:Create", src)
	TriggerClientEvent("animation:phonecall", src)
	TriggerClientEvent("chatMessage", src, "911 | " .. char.first_name .. " | " .. char.last_name .. " # " .. phonenumber, 3, tostring(message))

	local users = exports["np-base"]:getModule("Player"):GetUsers()

	local emergencyPlayers = {}

	for k,v in pairs(users) do
		local user = exports["np-base"]:getModule("Player"):GetUser(v)
		local job = user:getVar("job")

		if job == "ems" or job == "police" then
			emergencyPlayers[#emergencyPlayers+1]= v
		end
	end

	for k,v in ipairs(emergencyPlayers) do
		TriggerClientEvent("callsound", v)
		TriggerClientEvent("chatMessage", v, "911 | (" .. tonumber(src) .. ") " .. char.first_name .. " | " .. char.last_name .. " # " .. phonenumber, 3, tostring(message))
	end
end)

RegisterServerEvent("311")
AddEventHandler("311", function(args)
	local src = source

	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()
	local job = user:getVar("job")
	local message = ""

	local phonenumber = char.phone_number

	for k,v in ipairs(args) do
		message = message .. " " .. v
	end
	local caller = tostring(char.first_name) .. " " .. tostring(char.last_name)
	exports["np-log"]:AddLog("911 Chat", user, caller .. ": " .. message, {})

	-- TriggerClientEvent("GPSTrack:Create", src)
	TriggerClientEvent("animation:phonecall", src)
	TriggerClientEvent("chatMessage", src, "311 | " .. char.first_name .. " | " .. char.last_name .. " # " .. phonenumber, { 33, 118, 255 }, tostring(message))

	local users = exports["np-base"]:getModule("Player"):GetUsers()

	local emergencyPlayers = {}

	for k,v in pairs(users) do
		local user = exports["np-base"]:getModule("Player"):GetUser(v)
		local job = user:getVar("job")

		if job == "ems" or job == "police" then
			emergencyPlayers[#emergencyPlayers+1]= v
		end
	end

	for k,v in ipairs(emergencyPlayers) do
		TriggerClientEvent("callsound", v)
		TriggerClientEvent("chatMessage", v, "311 | (" .. tonumber(src) .. ") " .. char.first_name .. " | " .. char.last_name .. " # " .. phonenumber, { 33, 118, 255 }, tostring(message))
	end
end)

-- RegisterServerEvent("911a")
-- AddEventHandler("911a", function(args)
-- 	local src = source
-- 	table.remove(args, 1)

-- 	local user = exports["np-base"]:getModule("Player"):GetUser(src)
-- 	local char = user:getCurrentCharacter()
-- 	local job = user:getVar("job")
-- 	local message = ""

-- 	local phonenumber = char.phone_number

-- 	for k,v in ipairs(args) do
-- 		message = message .. " " .. v
-- 	end
-- 	local caller = tostring(char.first_name) .. " " .. tostring(char.last_name)
-- 	exports["np-log"]:AddLog("911 Chat", user, caller .. ": " .. message, {})

-- 	TriggerClientEvent("GPSTrack:Create", src)
-- 	TriggerClientEvent("animation:phonecall", src)
-- 	TriggerClientEvent("chatMessage", src, "911r | " .. char.first_name .. " " .. char.last_name .. " # " .. phonenumber, 3, tostring(message))

-- 	local users = exports["np-base"]:getModule("Player"):GetUsers()

-- 	local emergencyPlayers = {}

-- 	for k,v in pairs(users) do
-- 		local user = exports["np-base"]:getModule("Player"):GetUser(v)
-- 		local job = user:getVar("job")

-- 		if job == "ems" or job == "police" then
-- 			emergencyPlayers[#emergencyPlayers+1]= v
-- 		end
-- 	end

-- 	for k,v in ipairs(emergencyPlayers) do
-- 		TriggerClientEvent("callsound", v)
-- 		TriggerClientEvent("chatMessage", v, "911r | (" .. tonumber(src) .. ") " .. char.first_name .. " | " .. char.last_name .. " # " .. phonenumber, 3, tostring(message))
-- 	end
-- end)

RegisterServerEvent("fire:serverStopFire")
AddEventHandler("fire:serverStopFire", function(x,y,z, radius)
	TriggerClientEvent("fire:stopClientFires", -1, x,y,z, radius)
end)

RegisterServerEvent("911r")
AddEventHandler("911r", function(args)
	local src = source
	-- table.remove(args, 1)

	if not args[1] or not tonumber(args[1]) then return end
	local target = args[1]

	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()

	local job = user:getVar("job")

	local canRun = (job == "police" or job == "ems") and true or false
	if not canRun then return end

	local message = ""

	local caller = tostring(char.first_name) .. " " .. tostring(char.last_name)
	exports["np-log"]:AddLog("911r Chat", user, caller .. ": " .. message)

	for k,v in ipairs(args) do
		if k > 1 then
			message = message .. " " .. v
		end
	end
	TriggerClientEvent("animation:phonecall", src)

	local users = exports["np-base"]:getModule("Player"):GetUsers()

	local emergencyPlayers = {}

	for k,v in pairs(users) do
		local user = exports["np-base"]:getModule("Player"):GetUser(v)
		local job = user:getVar("job")

		if job == "ems" or job == "police" then
			emergencyPlayers[#emergencyPlayers+1]= v
		end
	end

	for k,v in ipairs(emergencyPlayers) do
		TriggerClientEvent("chatMessage", v, "911r -> " .. target .. " | " .. char.first_name .. ' ' .. char.last_name, 3, tostring(message))
	end

	TriggerClientEvent("chatMessage", target, "911r | (" .. tonumber(src) ..")", 3, tostring(message))
	exports["np-log"]:AddLog("911r Chat", user, char.first_name .. " " .. char.last_name .. ": ".. message, {target = target})
end)


RegisterServerEvent("311r")
AddEventHandler("311r", function(args)
	local src = source
	-- table.remove(args, 1)

	if not args[1] or not tonumber(args[1]) then return end
	local target = args[1]

	local user = exports["np-base"]:getModule("Player"):GetUser(src)
	local char = user:getCurrentCharacter()

	local job = user:getVar("job")

	local canRun = (job == "police" or job == "ems") and true or false
	if not canRun then return end

	local message = ""

	local caller = tostring(char.first_name) .. " " .. tostring(char.last_name)
	exports["np-log"]:AddLog("911r Chat", user, caller .. ": " .. message)

	for k,v in ipairs(args) do
		if k > 1 then
			message = message .. " " .. v
		end
	end
	TriggerClientEvent("animation:phonecall", src)

	local users = exports["np-base"]:getModule("Player"):GetUsers()

	local emergencyPlayers = {}

	for k,v in pairs(users) do
		local user = exports["np-base"]:getModule("Player"):GetUser(v)
		local job = user:getVar("job")

		if job == "ems" or job == "police" then
			emergencyPlayers[#emergencyPlayers+1]= v
		end
	end

	for k,v in ipairs(emergencyPlayers) do
		TriggerClientEvent("chatMessage", v, "311r -> " .. target .. " | " .. char.first_name .. ' ' .. char.last_name, { 33, 118, 255 }, tostring(message))
	end

	TriggerClientEvent("chatMessage", target, "311r | (" .. tonumber(src) ..")", { 33, 118, 255 }, tostring(message))
	exports["np-log"]:AddLog("911r Chat", user, char.first_name .. " " .. char.last_name .. ": ".. message, {target = target})
end)
--user:getVar("steamid")
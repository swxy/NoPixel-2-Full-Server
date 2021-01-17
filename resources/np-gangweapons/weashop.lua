local weashop = {
	opened = false,
	title = "Weapon store",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 255, b = 255, a = 100, type = 1 },
	menu = {
		x = 0.9,
		y = 0.08,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{title = "Melee Weapons", name = "Melee", description = ""},
				{title = "Pistols", name = "Pistols", description = ""},
				{title = "Machine guns", name = "MachineGuns", description = ""},
				{title = "Shotgun", name = "Shotguns", description = ""},
				{title = "Assault rifle", name = "AssaultRifles", description = ""},
				--{title = "Sniper rifle", name = "SniperRifles", description = ""},
				{title = "Heavy Weapons", name = "HeavyWeapons", description = ""},
				{title = "Thrown weapons", name = "ThrownWeapons", description = ""},
			}
		},
		["Melee"] = {
			title = "Melee Weapons",
			name = "Melee",
			buttons = {
				{title = "Petrol Can", name = "PetrolCan", costs = 100, description = {}, model = "WEAPON_PetrolCan"},
				{title = "Flare", name = "Flare", costs = 100, description = {}, model = "WEAPON_Flare"},
				{title = "Knife", name = "Knife", costs = 100, description = {}, model = "WEAPON_Knife"},
				{title = "Hammer", name = "Hammer", costs = 180, description = {}, model = "WEAPON_HAMMER"},
				{title = "Bat", name = "Bat", costs = 50, description = {}, model = "WEAPON_Bat"},
				{title = "Crowbar", name = "Crowbar", costs = 230, description = {}, model = "WEAPON_Crowbar"},
				{title = "Golfclub", name = "Golfclub", costs = 120, description = {}, model = "WEAPON_Golfclub"},
				{title = "Bottle", name = "Bottle", costs = 20, description = {}, model = "WEAPON_Bottle"},
				{title = "Dagger", name = "Dagger", costs = 120, description = {}, model = "WEAPON_Dagger"},
				{title = "Hatchet", name = "Hatchet", costs = 1200, description = {}, model = "WEAPON_Hatchet"},
				{title = "KnuckleDuster", name = "KnuckleDuster", costs = 1200, description = {}, model = "WEAPON_KNUCKLE"},
				{title = "Machete", name = "Machete", costs = 3000, description = {}, model = "WEAPON_Machete"},
				{title = "Flashlight", name = "Flashlight", costs = 120, description = {}, model = "WEAPON_Flashlight"},
				{title = "SwitchBlade", name = "SwitchBlade", costs = 120, description = {}, model = "WEAPON_SwitchBlade"},
				{title = "Poolcue", name = "Poolcue", costs = 120, description = {}, model = "WEAPON_Poolcue"},
				{title = "Wrench", name = "Wrench", costs = 100, description = {}, model = "WEAPON_Wrench"}
			}
		},

		["Pistols"] = {
			title = "Pistols",
			name = "Pistols",
			buttons = {
				{title = "Pistol", name = "Pistol", costs = 1500, description = {}, model = "WEAPON_Pistol"},
				{title = "Combat Pistol", name = "CombatPistol", costs = 2000, description = {}, model = "WEAPON_CombatPistol"},
				--{title = "SNS Pistol", name = "SNSPistol", costs = 4000, description = {}, model = "WEAPON_SNSPistol"},
				{title = "Vintage Pistol", name = "VintagePistol", costs = 3000, description = {}, model = "WEAPON_VintagePistol"},
				{title = "Stun Gun", name = "StunGun", costs = 3500, description = {}, model = "WEAPON_StunGun"},
			}
		},

		["MachineGuns"] = {
			title = "Machine guns",
			name = "MachineGuns",
			buttons = {

				{title = "MicroSMG (Illegal)", name = "MicroSMG", costs = 20000, description = {}, model = "WEAPON_MicroSMG"},
				{title = "SMG (Illegal)", name = "SMG", costs = 20000, description = {}, model = "WEAPON_SMG"},
				{title = "Assault SMG (Illegal)", name = "AssaultSMG", costs = 22800, description = {}, model = "WEAPON_AssaultSMG"},
				{title = "Gusenberg (Illegal)", name = "Gusenberg", costs = 32000, description = {}, model = "WEAPON_Gusenberg"},
			}
		},

		["Shotguns"] = {
			title = "Shotgun",
			name = "Shotguns",
			buttons = {
				{title = "Sawed-off Shotgun (Illegal)", name = "SawnoffShotgun", costs = 15000, description = {}, model = "WEAPON_SawnoffShotgun"},
				{title = "Bullpup Shotgun (Illegal)", name = "BullpupShotgun", costs = 20000, description = {}, model = "WEAPON_BullpupShotgun"},
				{title = "Assault Shotgun (Illegal)", name = "AssaultShotgun", costs = 20000, description = {}, model = "WEAPON_AssaultShotgun"},
				{title = "Heavy Shotgun (Illegal)", name = "HeavyShotgun", costs = 20000, description = {}, model = "WEAPON_HeavyShotgun"},
				{title = "Auto Shotgun (Illegal)", name = "Autoshotgun", costs = 33000, description = {}, model = "WEAPON_Autoshotgun"},
			}
		},

		["AssaultRifles"] = {
			title = "Assault Rifles",
			name = "AssaultRifles",
			buttons = {
				{title = "Assault Rifle (Illegal)", name = "AssaultRifle", costs = 45000, description = {}, model = "WEAPON_AssaultRifle"},
				{title = "Carbine Rifle (Illegal)", name = "CarbineRifle", costs = 45000, description = {}, model = "WEAPON_CarbineRifle"},
				{title = "Advanced Rifle (Illegal)", name = "AdvancedRifle", costs = 55000, description = {}, model = "WEAPON_AdvancedRifle"},
				{title = "Special Carbine (Illegal)", name = "SpecialCarbine", costs = 55000, description = {}, model = "WEAPON_SpecialCarbine"},
				{title = "Bullpup Rifle (Illegal)", name = "BullpupRifle", costs = 62000, description = {}, model = "WEAPON_BullpupRifle"},
			}
		},

		["SniperRifles"] = {
			title = "Sniper Rifles",
			name = "SniperRifles",
			buttons = {
				{title = "Sniper Rifle (Illegal)", name = "SniperRifle", costs = 150000, description = {}, model = "WEAPON_SniperRifle"},
				{title = "Heavy Sniper (Illegal)", name = "HeavySniper", costs = 200000, description = {}, model = "WEAPON_HeavySniper"},
				{title = "Marksman Rifle (Illegal)", name = "MarksmanRifle", costs = 250000, description = {}, model = "WEAPON_MarksmanRifle"},
			}
		},
		["HeavyWeapons"] = {
			title = "Heavy Weapons",
			name = "HeavyWeapons",
			buttons = {
				{title = "Firework", name = "Firework", costs = 200000, description = {}, model = "WEAPON_Firework"}
			}
		},
		["ThrownWeapons"] = {
			title = "Thrown Weapons",
			name = "ThrownWeapons",
			buttons = {
				{title = "Fire Extinguisher", name = "FireExtinguisher", costs = 9000, description = {}, model = "WEAPON_FireExtinguisher"}
			--	{title = "Smoke Grenade", name = "SmokeGrenade", costs = 32000, description = {}, model = "WEAPON_SmokeGrenade"}
			}
		},
	}
}

local StealthKills = {
    "ACT_stealth_kill_a",
    "ACT_stealth_kill_weapon",
    "ACT_stealth_kill_b",
    "ACT_stealth_kill_c",
    "ACT_stealth_kill_d",
    "ACT_stealth_kill_a_gardener"
}

Citizen.CreateThread(function()
    for _, killName in ipairs(StealthKills) do
        local hash = GetHashKey(killName)
        RemoveStealthKill(hash, false)
    end
end)

local fakeWeapon = ''
local weashop_locations = {
	{ entering = {1397.3756103516,1163.9971923828,114.33368682861}, inside = {1397.3756103516,1163.9971923828,114.33368682861}, outside = {1397.3756103516,1163.9971923828,114.33368682861} },
}

local weashop_blips ={}
local currentlocation = nil
local boughtWeapon = false

local function LocalPed()
return PlayerPedId()
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function IsPlayerInRangeOfweashop()
return inrangeofweashop
end

function ShowWeashopBlips(bool)
	if bool and #weashop_blips == 0 then
		for station,pos in pairs(weashop_locations) do
			local loc = pos
			pos = pos.entering

			weashop_blips[#weashop_blips+1]= {blip = blip, pos = loc}
		end

		Citizen.CreateThread(function()
			while #weashop_blips > 0 do
				Citizen.Wait(0)
				local inrange = false
				for i,b in ipairs(weashop_blips) do
					DrawMarker(27,b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,10,0,0,0,0)
					if weashop.opened == false and IsPedInAnyVehicle(LocalPed(), true) == false and  #(vector3(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3]) - GetEntityCoords(LocalPed())) < 2 then
						drawTxt('Press on ~g~E~s~ to buy or ~g~G~s~ to open stash',0,1,0.5,0.8,0.6,255,255,255,255)
						currentlocation = b
						inrange = true
					end
				end
			end
		end)

	elseif bool == false and #weashop_blips > 0 then
		for i,b in ipairs(weashop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		weashop_blips = {}
	end
end

function f(n)
	return n + 0.0001
end

function LocalPed()
	return PlayerPedId()
end

function try(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

--local veh = nil
function OpenCreator()
	boughtWeapon = false
	local ped = PlayerPedId()
	local pos = currentlocation.pos.inside
	FreezeEntityPosition(ped,true)
	SetEntityVisible(ped,false)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,pos[1],pos[2],g)
	SetEntityHeading(ped,pos[4])
	weashop.currentmenu = "main"
	weashop.opened = false
	weashop.selectedbutton = 0
end

function CloseCreator()

end

function drawMenuButton(button,x,y,selected)
	local menu = weashop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.title)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = weashop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,150)
	DrawText(0.365, 0.934)
end

function drawMenuRight(txt,x,y,selected)
	local menu = weashop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.03, y - menu.height/2 + 0.0028)
end

function drawMenuTitle(txt,x,y)
local menu = weashop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function Notify(text)
SetNotificationTextEntry('STRING')
AddTextComponentString(text)
DrawNotification(false, false)
end

function DoesPlayerHaveWeapon(model,button,y,selected, source)
	local t = false
	local hash = GetHashKey(model)
	--t = HAS_PED_GOT_WEAPON(source,hash,false) --Check if player already has selected weapon !!!! THIS DOES NOT WORK !!!!!
	if t then
		drawMenuRight("OWNED",weashop.menu.x,y,selected)
	else
		drawMenuRight(button.costs.." $",weashop.menu.x,y,selected)
	end
end
--[[
local backlock = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustPressed(1,38) and IsPlayerInRangeOfweashop() then
			if weashop.opened then
				CloseCreator()
			else
				OpenCreator()
			end
		end
		if IsControlJustPressed(1,47) and IsPlayerInRangeOfweashop() then
			TriggerServerEvent("np-weapons:checkinventory", "Ranch Main - 5mil")
		end

		if weashop.opened then
			local ped = LocalPed()
			local menu = weashop.menu[weashop.currentmenu]
			drawTxt(weashop.title,1,1,weashop.menu.x,weashop.menu.y,1.0, 255,255,255,255)
			drawMenuTitle(menu.title, weashop.menu.x,weashop.menu.y + 0.08)
			drawTxt(weashop.selectedbutton.."/"..tablelength(menu.buttons),0,0,weashop.menu.x + weashop.menu.width/2 - 0.0385,weashop.menu.y + 0.067,0.4, 255,255,255,255)
			local y = weashop.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= weashop.menu.from and i <= weashop.menu.to then

					if i == weashop.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,weashop.menu.x,y,selected)
					if button.costs ~= nil then
						DoesPlayerHaveWeapon(button.model,button,y,selected,ped)
					end
					y = y + 0.04
					if selected and IsControlJustPressed(1,38) then
						ButtonSelected(button)
					end
				end
			end
		end
		if weashop.opened then
			if IsControlJustPressed(1,202) then
				Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if weashop.selectedbutton > 1 then
					weashop.selectedbutton = weashop.selectedbutton -1
					if buttoncount > 10 and weashop.selectedbutton < weashop.menu.from then
						weashop.menu.from = weashop.menu.from -1
						weashop.menu.to = weashop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if weashop.selectedbutton < buttoncount then
					weashop.selectedbutton = weashop.selectedbutton +1
					if buttoncount > 10 and weashop.selectedbutton > weashop.menu.to then
						weashop.menu.to = weashop.menu.to + 1
						weashop.menu.from = weashop.menu.from + 1
					end
				end
			end
		end

	end
end)]]

RegisterNetEvent('FinishMoneyCheckForWeaGang')
AddEventHandler('FinishMoneyCheckForWeaGang', function()
	boughtWeapon = true
	CloseCreator()
end)

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function ButtonSelected(button)
	local ped = PlayerPedId()
	local this = weashop.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Melee" then
			OpenMenu('Melee')
		elseif btn == "Pistols" then
			OpenMenu('Pistols')
		elseif btn == "MachineGuns" then
			OpenMenu('MachineGuns')
		elseif btn == "Shotguns" then
			OpenMenu('Shotguns')
		elseif btn == "AssaultRifles" then
			OpenMenu('AssaultRifles')
		elseif btn == "SniperRifles" then
			OpenMenu('SniperRifles')
		elseif btn == "HeavyWeapons" then
			OpenMenu('HeavyWeapons')
		elseif btn == "ThrownWeapons" then
			OpenMenu('ThrownWeapons')
		end
	else
		fakeWeapon = button.model
		TriggerServerEvent('CheckMoneyForWeaGang',GetHashKey(button.model),button.costs)
	end
end

function OpenMenu(menu)
	weashop.lastmenu = weashop.currentmenu
	weashop.menu.from = 1
	weashop.menu.to = 10
	weashop.selectedbutton = 0
	weashop.currentmenu = menu
end

function Back()
	if backlock then
		return
	end
	backlock = true
	if weashop.currentmenu == "main" then
		boughtWeapon = false
		CloseCreator()
	else
		OpenMenu(weashop.lastmenu)
	end
end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

RegisterNetEvent('ResetFirstSpawn')
AddEventHandler('ResetFirstSpawn', function()
	gangmember = false
end)

-- show only for gang members
local firstspawn = 0
local gangmember = false


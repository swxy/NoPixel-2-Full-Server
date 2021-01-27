isCop = false
isInService = false
local blips = {

  {name = "Police Station 1", id = 60, x = 425.130, y = -979.558, z = 30.711},
  {name= "Police Station 2", id=60, x=850.156677246094, y=-1283.92004394531, z=28.0047378540039},
  {name= "Police Station 3", id=60, x=1856.91320800781, y=3689.50073242188, z=34.2670783996582},
  {name= "Police Station 4", id=60, x=-450.063201904297, y=6016.5751953125, z=31.7163734436035},
  {name= "Forensic HQ", id=60, x = 638.8463134765, y = 1.44993293283,z = 82.78640747074},
  {name = "Police Air HQ", id = 43, x = 449.359, y = -980.727, z = 42.60},
  {name = "Prison", id = 60, x = 1679.049, y = 2513.711, z = 45.565},
  {name = "Hospital", id=61, x= 357.43, y= -593.36, z= 28.79},
}

Citizen.CreateThread(function()
  for _, item in pairs(blips) do
    item.blip = AddBlipForCoord(item.x, item.y, item.z)
    SetBlipSprite(item.blip, item.id)
	SetBlipScale(item.blip, 0.8)
	SetBlipColour(item.blip, 3)
    SetBlipAsShortRange(item.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(item.name)
    EndTextCommandSetBlipName(item.blip)
  end
end)

function LocalPed()
	return PlayerPedId()
end

function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

RegisterNetEvent("notworked")
AddEventHandler("notworked", function()
	TriggerEvent("DoLongHudText", "You are not signed in!!",2 );
end)

RegisterNetEvent("worked")
AddEventHandler("worked", function()
	TriggerEvent("DoLongHudText", "Vehicle available !",1 );
end)

RegisterNetEvent('nowCopGarage')
AddEventHandler('nowCopGarage', function()
	TriggerServerEvent("TokoVoip:addPlayerToRadio", 1, GetPlayerServerId(PlayerId()))
    TriggerEvent("ChannelSet",1)
  	isCop = true
	isInService = true
    TriggerEvent('nowCop')
    TriggerEvent('nowService')
		TriggerEvent('nowCopHud')
		TriggerEvent('nowCopDeath')
		TriggerEvent('nowCopSpawn')
		TriggerEvent('nowMedic')
		SetPedRelationshipGroupDefaultHash(PlayerPedId(),`MISSION2`)
		SetPedRelationshipGroupHash(PlayerPedId(),`MISSION2`)
		SetPoliceIgnorePlayer(PlayerPedId(),true)
		TriggerEvent("armory:ammo")
end)


local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


-- NEW VERSION
local cmd = {
	["classic"] = { event = 'policeg:s_classic' },
	["moto"] = { event = 'policeg:s_moto' },
	["fila"] = { event = 'policeg:s_fila' },
	["helico"] = { event = 'policeg:s_helico' },
}
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function InitMenuVehicules()
	if isCop then
		TriggerEvent('sendToGui','Cruiser','policeg:c_classic')
		TriggerEvent('sendToGui','UM CVPI','policeg:c_fila')
		TriggerEvent('sendToGui','Motorbike','policeg:c_moto')
		TriggerEvent('sendToGui','Charger','policeg:c_porsche')
		TriggerEvent('sendToGui','k9 Charger','policeg:c_charger')
	else
		TriggerEvent("DoLongHudText",'You are not an Officer!',2)
	end
end

function InitMenuHelico()
	TriggerEvent('sendToGui','Helicopter','policeg:s_helico')
end

function callSE(evt)
	Menu.hidden = not Menu.hidden
	Menu.renderGUI()
	TriggerServerEvent(evt)
end

function ShowRadarMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end

--Citizen.Trace(GetEntityModel(PlayerPedId()))
local takingService = {
{x=2131.3840332031, y=2925.5268554688, z=-61.901893615723},
{x=441.25, y=-981.89, z=30.689598083496},
{x=834.410400390625, y=-1263.51831054688, z=26.068798065185},
{x=1859.45373535156, y=3676.70166015625, z=33.4029159545898},
{x=-460.097320556641, y=6023.5498046875, z=31.3405303955078},
{x=1838.07,y=2591.75, z=46.02},

 -- {x=850.156677246094, y=-1283.92004394531, z=28.0047378540039},
 -- {x=457.956909179688, y=-992.72314453125, z=30.6895866394043}
 -- {x=1856.91320800781, y=3689.50073242188, z=34.2670783996582},
 -- {x=-450.063201904297, y=6016.5751953125, z=31.7163734436035}
}


function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


function isNearTakeService()
	for i = 1, #takingService do
		local ply = PlayerPedId()
		local plyCoords = GetEntityCoords(ply, 0)
		local distance = #(vector3(takingService[i].x, takingService[i].y, takingService[i].z) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
		if(distance < 3.0) then
			DrawText3Ds(takingService[i].x, takingService[i].y, takingService[i].z, "[E] On Duty [G] Off Duty" )
		end
		if(distance < 3.0) then
			return true
		end
	end
end




RegisterNetEvent('event:control:policeGarage')
AddEventHandler('event:control:policeGarage', function(useID)
	if useID == 1 then
		TriggerServerEvent('attemptduty')
		TriggerEvent('raid_clothes:inService', true)
	elseif useID == 2 then
		if isCop then
		    isCop = false
			isInService = false
			TriggerEvent('raid_clothes:inService', false)
			TriggerServerEvent("TokoVoip:removePlayerFromAllRadio",GetPlayerServerId(PlayerId()))
			TriggerServerEvent("jobssystem:jobs", "unemployed")
			TriggerServerEvent('myskin_customization:wearSkin')
			TriggerServerEvent('tattoos:retrieve')
			TriggerServerEvent('Blemishes:retrieve')
			TriggerEvent("police:noLongerCop")
			TriggerEvent("logoffmedic")		
			TriggerEvent("loggedoff")					
			TriggerEvent('nowCopDeathOff')
		    TriggerEvent('nowCopSpawnOff')
		    TriggerEvent('nowMedicOff')
		    TriggerServerEvent("TokoVoip:clientHasSelecterCharecter")

		    SetPedRelationshipGroupHash(PlayerPedId(),`PLAYER`)
		    SetPedRelationshipGroupDefaultHash(PlayerPedId(),`PLAYER`)
		    SetPoliceIgnorePlayer(PlayerPedId(),false)
		    TriggerEvent("DoLongHudText",'Signed off Duty!',1)
	    end		
	end
end)

local inttrack = 0;
Citizen.CreateThread(function()
	SetScenarioTypeEnabled( "WORLD_VEHICLE_STREETRACE", false )
	SetScenarioTypeEnabled( "WORLD_VEHICLE_SALTON_DIRT_BIKE", false )
	SetScenarioTypeEnabled( "WORLD_VEHICLE_SALTON", false )
	SetScenarioTypeEnabled( "WORLD_VEHICLE_POLICE_NEXT_TO_CAR", false )
	SetScenarioTypeEnabled( "WORLD_VEHICLE_POLICE_CAR", false )
	SetScenarioTypeEnabled( "WORLD_VEHICLE_POLICE_BIKE", false )
	SetScenarioTypeEnabled( "WORLD_VEHICLE_MILITARY_PLANES_SMALL", false )
	SetScenarioTypeEnabled( "WORLD_VEHICLE_MILITARY_PLANES_BIG", false )
	SetScenarioTypeEnabled( "WORLD_VEHICLE_MECHANIC", false )
	SetScenarioTypeEnabled( "WORLD_VEHICLE_EMPTY", false )
	SetScenarioTypeEnabled( "WORLD_VEHICLE_BUSINESSMEN", false )
	SetScenarioTypeEnabled( "WORLD_VEHICLE_BIKE_OFF_ROAD_RACE", false )

	while true do
		Citizen.Wait(0)
		if isNearTakeService() then		
		else
			Wait(1200)
		end
	end
end)



function ChangeToFrancis(skin)
	local model = GetHashKey(skin)
	if IsModelInCdimage(model) and IsModelValid(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end
		SetPlayerModel(PlayerId(), model)
	else
		TriggerEvent("DoLongHudText","Model not found",2)
	end
end
local PedRestricted = true
local VehicleRestricted = true
local GodmodeDog = false
local thecount = 0
local ragdol = 1    
local imDead = 0
local dogTypeG = 1
local current_dog = 0

local currentState = ""

local PedList = {
	-- Police --
	`s_m_y_cop_01`,
	`s_f_y_cop_01`,
	-- Highway --
	`s_m_y_hwaycop_01`,
	-- Sheriff --
	`s_m_y_sheriff_01`,
	`s_f_y_sheriff_01`,
	-- SWAT --
	`s_m_y_swat_01`,
	-- Ranger --
	`s_m_y_ranger_01`,
	`s_f_y_ranger_01`,
}

local VehicleList = {
	"pol1", -- cvpi
	"pol2", -- cvpi
	"pol3", -- taurus
	"pol5", -- tahoe LB
	"pol6", -- tahoe ST
	"pol8", -- Bike
	"pol9", -- Truck
	"police2", -- charger
	"pol10", -- Swat
	"maverick2", -- keep
	"predator", -- keep
	"pbus2", -- keep
	"policet", -- keep
	"flatbed2", -- PD tow truck.
	"polvic",
	"polvic2",
	"poltah",
	"poltaurus"
}

local following = false
local attacking = false
local animation_played = nil
local dog_name = "Bob"

local other_ped_attacked = nil

function lerp(x1, y1, z1, x2, y2, z2, t) 
      local x = x1 + (x2 - x1) * t
      local y = y1 + (y2 - y1) * t
      local z = z1 + (z2 - z1) * t
     return x, y, z
end

function onRender()
    --if IsControlPressed(1, 38) then
        aiming, ent = GetEntityPlayerIsFreeAimingAt(PlayerId())
        if aiming and ent and IsEntityAPed(ent) then
            health=GetEntityHealth(ent) or 0.0
            maxHealth=GetEntityMaxHealth(ent)-100 or 0.0
            val=(health/2)/maxHealth
            if IsPedDeadOrDying(ent, 1) then
                r,g,b=0,0,0
            else
                r,g,b=lerp(255,0,0,0,255,0,val)
            end
            --r,g,b=lerp(255,0,0,0,255,0,0.5)

            x1,y1,z1 = table.unpack(GetWorldPositionOfEntityBone(ent, i))

            DrawMarker(0,x1,y1,z1+1.0, 0.0, 0.0, 0.0, 0, 0, 0, 2.0, 2.0, -0.1, r,g,b , 50, false, true, false, false)
        end
    --end
end

Citizen.CreateThread(function()
	RequestModel("a_c_coyote")
	while not HasModelLoaded("a_c_coyote") do
		RequestModel("a_c_coyote")
		Citizen.Wait(100)
	end	

    while true do
        Wait(1)
        if (current_dog ~= 0) then
       		onRender()
		else
			Wait(2000)
		end
	end
end)

function k9message(inputText)
	SetNotificationTextEntry("STRING");
	AddTextComponentString(inputText);
	SetNotificationMessage("CHAR_CHOP", "CHAR_CHOP", true, 1, "~y~K9:~s~", "");
	DrawNotification(false, true);
end


RegisterNetEvent("K9:Create")
AddEventHandler("K9:Create", function(dogType)
		dogTypeG = dogType
		if (current_dog ~= 0) then
			TriggerEvent("K9:Delete")
		end
		local model

		model = `a_c_chop`
		
		RequestModel(model)
		while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(100)
		end		




		local plypos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 2.0, 0.0)
		local plyhead = GetEntityHeading(GetPlayerPed(PlayerId()))
		local spawned_entity = CreatePed(GetPedType(model), model, plypos.x, plypos.y, plypos.z, plyhead, 1, 0)
		SetBlockingOfNonTemporaryEvents(spawned_entity, true)
		SetPedFleeAttributes(spawned_entity, 0, 0)
		current_dog = spawned_entity
		SetEntityAsMissionEntity(current_dog,false,true)
		SetPedMaxHealth(current_dog, 9000) 
		SetEntityHealth(current_dog, 9000)
		SetPedDiesWhenInjured(current_dog, true)

		SetPedComponentVariation(current_dog,3,1,0,0)

		if tonumber(dogType)  == 2 then
			SetPedComponentVariation(current_dog,3,1,1,0)
		end

		if tonumber(dogType)  == 3 then
			SetPedComponentVariation(current_dog,3,1,2,0)
		end

		-- coyote
		local blip = AddBlipForEntity(current_dog)
		SetBlipAsFriendly(blip, true)
		SetBlipSprite(blip, 442)
		BeginTextCommandSetBlipName("STRING");
		AddTextComponentString(tostring("K9"))
		EndTextCommandSetBlipName(blip)


		local netid = NetworkGetNetworkIdFromEntity(current_dog)

		Citizen.Wait(1000)
		Citizen.Trace(netid)


		SetNetworkIdCanMigrate(netid, false)

		TaskGoToEntity(current_dog,PlayerPedId(),-1,1.0,2.0,1073741824,0)
		hunting = false
		attacking = false
		animation_played = nil

		TriggerEvent("DoLongHudText","K9: Now in service")
end)


RegisterNetEvent("K9:Delete")
AddEventHandler("K9:Delete", function()
	local ldog = current_dog
	current_dog = 0
	SetEntityAsMissionEntity(ldog,false,true)
	DeleteEntity(ldog)
	TriggerEvent("DoLongHudText","K9: Now out of service")
	
end)

RegisterNetEvent("K9:Vehicle")
AddEventHandler("K9:Vehicle", function()
	if not following then 
		TriggerEvent("K9:Follow")
	end
	if IsPedInAnyVehicle(current_dog, false) and imDead == 0 then
		ClearPedTasks(current_dog)
		dogvehicled = false
		plyPos = GetEntityCoords(PlayerPedId(),  true)
		local xnew = plyPos.x+1
		local ynew = plyPos.y+1

		SetEntityCoords(current_dog, xnew, ynew, plyPos.z+0.3)
		--TriggerEvent("K9:Follow")
		--TaskLeaveVehicle(current_dog, GetVehiclePedIsIn(current_dog, false), 256)

	else

		local plyPos = GetEntityCoords(PlayerPedId(), false)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
		if CheckVehicleRestriction(vehicle) == true and imDead == 0 then
			attacking = falses
		    for i=1,GetVehicleMaxNumberOfPassengers(vehicle) do
		      if IsVehicleSeatFree(vehicle,i) then
		      	RequestAnimDict("creatures@rottweiler@in_vehicle@std_car")
				Citizen.Wait(100)
				TaskPlayAnim(current_dog, "creatures@rottweiler@in_vehicle@std_car", "sit", 1.0, -1, -1, 2, 0, 0, 0, 0)
		        SetPedIntoVehicle(current_dog,vehicle,0)
				dogvehicled = true	
				sit(current_dog)		    
		        return true
		      end
		    end
		end

	end
end)

RegisterNetEvent("K9:Follow")
AddEventHandler("K9:Follow", function()
	hunting = false
	attacking = false
	animation_played = nil
	if current_dog ~= 0 then
		if following == false then
			ClearPedTasks(current_dog)
			Citizen.Wait(200)
			following = true
			currentState = "F"
			TriggerEvent("DoLongHudText","K9: Follow")
		else
			ClearPedTasks(current_dog)
			following = false
			currentState = "S"
			TriggerEvent("DoLongHudText","K9: Stay")
		end
	end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

local dogvehicled = false
-- 0 means requiring check or outside a vehicle
-- 1 means we are inside a vehicle, though, not a police car
-- 2 means we are inside a pd vehicle.
local invehiclecheck = 0
Citizen.CreateThread(function()
	while true do
		local dick = PlayerPedId()

		--if current_dog ~= nil then
		--	SetPedMaxHealth(current_dog, 100000) 
		--	SetEntityHealth(current_dog, 100000)
		--end
		-- Follow Key --
		if current_dog == 0 then
			Wait(3000)
		else

			Citizen.Wait(1)
			if IsControlJustPressed(1, 243) and not IsPlayerFreeAiming(PlayerId()) and not IsControlPressed(1, 19) then
				TriggerEvent("K9:Follow")
			end

			-- Attacking Key --
			if IsPlayerFreeAiming(PlayerId()) and IsControlJustPressed(1, 10) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
				TriggerEvent("K9:Attack")
			end

			--[[
			if IsPedSittingInAnyVehicle(PlayerPedId()) and not dogvehicled then
				print("FUCK KOIL")
				TriggerEvent("K9:Vehicle")
			end

			if not IsPedSittingInAnyVehicle(PlayerPedId()) and dogvehicled then
				print("FUCK KOIL2")
				TriggerEvent("K9:Vehicle")
			end ]]--

			if IsControlPressed(0, 47) and not IsPedSittingInAnyVehicle(PlayerPedId()) then
				TriggerEvent("K9:Huntfind")
			end

			-- If other ped attacking dies it stops attacking --
			if attacking == true then
				if IsPedDeadOrDying(other_ped_attacked, 1) then
					TriggerEvent("K9:Attack")
				end
			end

			if current_dog ~= 0 then
				local color = {32, 126, 188}
				if currentState == "A" or currentState == "H" or currentState == "D" then color = {188, 39, 32} end
				drawTxt(0.657, 1.4680, 1.0,1.0,0.33 , ""..currentState.."", 32, 126, 188, 255)
			end

		
			
		end

	end
end)

--TaskGoStraightToCoord(current_dog, x, y, z, speed, timeout, targetHeading, distanceToSlide)


local lastCommandTime = 0
local lastDogCoords = {}
local huntedPed = nil
--[[
Citizen.CreateThread(function()

	while true do

		Citizen.Wait(3)
		if IsPedInMeleeCombat(PlayerPedId()) and current_dog ~= 0 and imDead == 0 and not attacking then
			k9message(tostring("Dog, Attack!")) -- Attack
			attackClosest()
		end
		c1 =  GetOffsetFromEntityInWorldCoords(PlayerPedId(), 170.0, 170.0, 60.0)
		c2 =  GetOffsetFromEntityInWorldCoords(PlayerPedId(), -170.0, -170.0, -60.0)
		if IsAnyPedShootingInArea(c1,c2,false,false) then
			local shoot = nil
			shoot = IsPedShootingInArea(PlayerPedId(),c1,c2,false,false)
			if shoot ~= 1 then
				attackShooter()
			end
		end

		if current_dog == 0 then
			Wait(1200)
		end

	end
end)
]]
function FindShooter()
    local players = {}
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
        	if i ~= PlayerId() then 
	        	local ped = GetPlayerPed(i)
	        	if ped ~= PlayerPedId() then
	        		local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
	            	local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
	            	if distance < 70 then
	            		players[#players+1]= i
	            	end
	        	end
	        end
        end
    end

    return players
end


function attackShooter()
	local players = FindShooter()
	if players == nil then return end
    local closestPlayer = -1
    local ply = PlayerPedId()
    local dog_ped = current_dog
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
        	if not CheckPedRestriction(target) then
	            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
	            closestPlayer = target
	        end
        end
    end
	if current_dog == nil then return end
	if closestPlayer == PlayerPedId() then return end
	if closestPlayer == -1 then return end
	local plyCoords = GetEntityCoords(closestPlayer, 0)
	local targetCoords = GetEntityCoords(dog_ped, 0)
	local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
	if distance > 70 then return end
	if not IsEntityDead(closestPlayer) then
		SetCanAttackFriendly(dog_ped, true, true)
		TaskPutPedDirectlyIntoMelee(dog_ped, closestPlayer, 0.0, -1.0, 0.0, 0)
		other_ped_attacked = closestPlayer
		attacking = true
		following = false
		hunting = false
	end
   	 
end

function attackClosest()
	ClearPedTasks(current_dog)
	local dog_ped = current_dog
	local other_ped, dist = GetClosestPlayer()
	other_ped_attacked = other_ped
	if current_dog == nil then return end
	if other_ped == PlayerPedId() then return end
	if not IsEntityDead(other_ped) then
		SetCanAttackFriendly(dog_ped, true, true)
		TaskPutPedDirectlyIntoMelee(dog_ped, other_ped, 0.0, -1.0, 0.0, 0)
		other_ped_attacked = other_ped
		attacking = true
		following = false
		hunting = false
		
	end
end

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end


function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
            closestPlayer = target
            closestDistance = distance
        end
    end
    
    return closestPlayer, closestDistance
end

local hasRagdolled = 0 

Citizen.CreateThread(function()

	while true do

		if current_dog == 0 then
			Wait(1200)
		else
			Citizen.Wait(1)
			pedcoords = GetEntityCoords(PlayerPedId())
			dogcoords = GetEntityCoords(current_dog)
			distancecheck = #(pedcoords - dogcoords)
			if following and distancecheck > 35.0 and imDead == 0 then
				SetEntityInvincible(current_dog, true)
				tp =  GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0)
				SetEntityCoords(current_dog,tp)
				Citizen.Wait(1000)
				SetEntityInvincible(current_dog, false)
				TaskGoToEntity(current_dog,PlayerPedId(),-1,1.0,2.0,1073741824,0)
			end

			if other_ped_attacked ~= nil and attacking and imDead == 0 then
				targetCoords = GetEntityCoords(other_ped_attacked)
				dog = GetEntityCoords(current_dog)
				dist = #(targetCoords - dogcoords)
				local time = GetGameTimer() - lastCommandTime
				if dist < 1 then
					hasRagdolled = hasRagdolled + 1 
					if hasRagdolled == 1 or hasRagdolled > 1200 then
						SetPedToRagdoll(other_ped_attacked, 5000, 5000, 0, 0, 0, 0)
						if hasRagdolled > 1200 then
							hasRagdolled = 0
						end
					end
				end
			end

		end

	end

end)
local timer = 0 

Citizen.CreateThread(function()

	while true do

		if current_dog == 0 then
			Wait(1200)
		else


			Citizen.Wait(300)
			pedcoords = GetEntityCoords(PlayerPedId())
			dogcoords = GetEntityCoords(current_dog)
			distancecheck = #(pedcoords - dogcoords)
			dist = #(lastDogCoords - dogcoords)	
			if current_dog ~= 0 and not attacking and imDead == 0 and distancecheck > 5 then
				local jump = VehicleInFront()
				if jump == 1 then
					if dist < 0.4 then
						timer = timer + 1
						if timer > 10 then
							SetEntityInvincible(current_dog, true)
							tp =  GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)
							SetEntityCoords(current_dog,tp)
							Citizen.Wait(1000)
							SetEntityInvincible(current_dog, false)
							TaskGoToEntity(current_dog,PlayerPedId(),-1,1.0,2.0,1073741824,0)
						end
					end
				else
					timer = 0
				end
			end

		end


	end

end)


function VehicleInFront()
    local pos = GetEntityCoords(current_dog)
    local entityWorld = GetOffsetFromEntityInWorldCoords(current_dog, 0.0, 2.5, -0.2)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 1, current_dog, 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return b
end

Citizen.CreateThread(function()
	

	while true do

		if current_dog == 0 then
			Wait(1200)
		else

			Citizen.Wait(100)
			local localPed = PlayerPedId()
			pedcoords = GetEntityCoords(localPed)
			dogcoords = GetEntityCoords(current_dog)
			distancecheck = #(pedcoords - dogcoords)	
			local time = GetGameTimer() - lastCommandTime	
			if following and distancecheck > 3 and distancecheck < 15 and imDead == 0 then			
				if time > 2500 or lastCommandTime == 0  then
					local dist = #(dogcoords - lastDogCoords)
					if dist < 0.1 then
						if IsPedSprinting(localPed) then
							lastCommandTime = GetGameTimer()
							TaskGoToEntity(current_dog,localPed,-1,4.0,30.0,1073741824,0)
						else
							lastCommandTime = GetGameTimer()
							TaskGoToEntity(current_dog,localPed,-1,1.0,2.0,1073741824,0)
						end
					end
				end
			end

			if following and distancecheck > 14 and distancecheck < 25 and imDead == 0 then			
				if time > 2500 or lastCommandTime == 0  then
					local dist = #(dogcoords - lastDogCoords)
					if dist < 0.1 then
						TaskGoToEntity(current_dog,localPed,-1,4.0,30.0,1073741824,0)
					end
				end
			end

			
	           
			if following and distancecheck > 25 and imDead == 0  then
				SetEntityInvincible(current_dog, true)
				tp =  GetOffsetFromEntityInWorldCoords(localPed, 1.0, 1.0, -1.0)
				SetEntityCoords(current_dog,tp)
				Citizen.Wait(1000)
				SetEntityInvincible(current_dog, false)
				TaskGoToEntity(current_dog,localPed,-1,1.0,2.0,1073741824,0)
			end

			if hunting then
				currentState = "H"
				pedcoords = hunt_coords
				dogcoords = GetEntityCoords(current_dog)
				distancecheck = #(vector3(pedcoords[1],pedcoords[2],pedcoords[3]) - dogcoords)
				
				local chance = math.random(100)
				if chance > 10 and distancecheck < 3 and imDead == 0  then
					intimidate(current_dog)
					hunting = false
					attacking = false
					following = false
					TriggerEvent("DoLongHudText","K9: The dog smells something very close..")			
				else
					if distancecheck > 120 and imDead == 0  then
						hunting = false
						attacking = false
						following = false
						TriggerEvent("DoLongHudText","K9: The dog lost the sent..")	
					else
						if time > 1700 or lastCommandTime == 0 and imDead == 0 then
							local dist = #(dogcoords - lastDogCoords)
							if dist < 0.1 then
								lastCommandTime = GetGameTimer()
								TaskGoToEntity(current_dog,huntedPed,-1,4.0,30.0,1073741824,0)
							end
						end
					end
				end
			end
			
			lastDogCoords = dogcoords

		end
		
	end
end)

local commands = {
	[1] = "spawn : Spawn the K9",
	[2] = "sit : Have the K9 Sit",
	[3] = "lay : Have the K9 Lay",
	[4] = "hunt : Have the K9 hunt for a person",
	[5] = "person : Have the K9 sniff person",
	[6] = "vehicle : Have the K9 sniff a vehicle",
	[7] = "stand : Have the K9 stand",
}


RegisterNetEvent("K9:commands")
AddEventHandler("K9:commands", function(args)
	if args == nil then return end
	
	if args[2] == nil then
		TriggerEvent("openSubMenu","K9 Menu")
	end

	if args[2] == "spawn" then
		TriggerEvent("K9:Create",args[3])
	end

	if args[2] == "help" then
		commandString = ""

		for k,v in pairs(commands) do
	        commandString = commandString .. " ".. k .. " - " .. v .. " \n "
	    end 
	    TriggerEvent("chatMessage", "", 4 , commandString)
	end

	if args[2] == "lay" then
		TriggerEvent("K9:Lay")
	end

	if args[2] == "sit" then
		TriggerEvent("K9:Sit")
	end

	if args[2] == "person" then
		TriggerEvent("K9:Sniff")
	end

	if args[2] == "vehicle" then
		TriggerEvent("sniffVehicle")
	end

	if args[2] == "stand" then
		TriggerEvent("K9:Stand")
	end

	if args[2] == "hunt" then
		TriggerEvent("K9:Huntfind")
	end	
end)


 hunting = false


RegisterNetEvent("K9:HuntAccepted")
AddEventHandler("K9:HuntAccepted", function()
	ClearPedTasks(current_dog)
	hunt_coords = other_coords
	if hunting == false then
		-- huntedPed = GetPlayerPed(GetPlayerFromServerId(other_ped))
		hunting = true
		attacking = false
		following = false
		attackClosest()
	--	TriggerEvent("DoLongHudText","K9:"..tostring("Dog is hunting roughly " .. other_distance .. " metres away.".. other_coords[1] .."".. other_coords[2] .."".. other_coords[3] ..""))	
		k9message()
	else
		huntedPed = nil
		hunting = false
		attacking = false
		following = false		
		ClearPedTasks(current_dog)
		TriggerEvent("DoLongHudText","K9: Good Dog!")
	end

end)

RegisterNetEvent("K9:Attack")
AddEventHandler("K9:Attack", function()
	ClearPedTasks(current_dog)
	local dog_ped = current_dog
	local bool, other_ped = GetEntityPlayerIsFreeAimingAt(PlayerId())
	other_ped_attacked = other_ped
	if other_ped == PlayerPedId() then return end
	if attacking == false then
		if IsEntityAPed(other_ped) then
			if not IsEntityDead(other_ped) then
				SetCanAttackFriendly(dog_ped, true, true)
				TaskPutPedDirectlyIntoMelee(dog_ped, other_ped, 0.0, -1.0, 0.0, 0)
				other_ped_attacked = other_ped
				attacking = true
				following = false
				hunting = false
				currentState = "A"
				TriggerEvent("DoLongHudText","K9: Dog, Attack!")
			end
		end
	else
		attacking = false
		other_ped_attacked = nil
		ClearPedTasks(dog_ped)
		TriggerEvent("DoLongHudText","K9: Good Dog!") -- Stopping Dog (Good Dog)
	end
end)

RegisterNetEvent("K9:Lay")
AddEventHandler("K9:Lay", function()
	ClearPedTasks(current_dog)
	laydown(current_dog)

	attacking = false
	following = false
	hunting = false

end)

RegisterNetEvent("K9:Stand")
AddEventHandler("K9:Stand", function()
	ClearPedTasks(current_dog)
	TriggerEvent("K9:Follow")
	attacking = false
	following = false
	hunting = false

end)


RegisterNetEvent("K9:Sit")
AddEventHandler("K9:Sit", function()
	ClearPedTasks(current_dog)
	sit(current_dog)

	attacking = false
	following = false
	hunting = false

end)

RegisterNetEvent("K9:SniffConfirmedFail")
AddEventHandler("K9:SniffConfirmedFail", function()
	ClearPedTasks(current_dog)
	failed(current_dog)
	attacking = false
	following = false	
	hunting = false
	TriggerEvent("DoLongHudText","K9: Dog smells nothing!")
end)


RegisterNetEvent("judge:cm")
AddEventHandler("judge:cm", function()
	local model = `u_m_y_coop`
	while not HasModelLoaded(model) do
		RequestModel(model)

		Citizen.Wait(0)
	end
	SetPlayerModel(PlayerId(), model)
end)



RegisterNetEvent("K9:SniffConfirmed")
AddEventHandler("K9:SniffConfirmed", function()
	local chance = math.random(100)
	if chance > 10 then
		intimidate(current_dog)
		attacking = false
		following = false
		hunting = false
		TriggerEvent("DoLongHudText","K9: Dog smells something funny!")
	else
		TriggerEvent("DoLongHudText","K9: Dog smells nothing!")
	end

end)

function failed(entity)

	ClearPedSecondaryTask(current_dog)
	local animdicstart = "creatures@coyote@amb@world_coyote_howl@enter"
	local animnamestart = "enter"
	local animdicend = "creatures@coyote@amb@world_coyote_howl@exit"
	local animnameend = "exit"
	RequestAnimDict(animdicstart)
	Citizen.Wait(100)
	TaskPlayAnim(current_dog, animdicstart, animnamestart, 1.0, -1, -1, 2, 0, 0, 0, 0)
	animation_played = "intimidate"

end



function intimidate(entity)

	ClearPedSecondaryTask(current_dog)
	--PlaySound(-1, "DISTANT_DOG_BARK", current_dog, "CAR_STEAL_2_SOUNDSET", 0, 0, 1) --- still need anim set for this will look later
	local animdicstart
	local animnamestart
	local animdicend
	local animnameend

	animdicstart = "creatures@rottweiler@melee@streamed_taunts@"
	animnamestart = "taunt_01"
	animdicend = "creatures@rottweiler@melee@streamed_taunts@"
	animnameend = "taunt_01"

	RequestAnimDict(animdicstart)
	Citizen.Wait(100)
	TaskPlayAnim(current_dog, animdicstart, animnamestart, 1.0, -1, -1, 2, 0, 0, 0, 0)
	animation_played = "intimidate"


	Wait(900)

	animdicstart = "creatures@rottweiler@tricks@"
	animnamestart = "sit_enter"
	animdicend = "creatures@rottweiler@tricks@"
	animnameend = "sit_exit"

	RequestAnimDict(animdicstart)
	Citizen.Wait(100)
	TaskPlayAnim(current_dog, animdicstart, animnamestart, 1.0, -1, -1, 2, 0, 0, 0, 0)
	animation_played = "sit"

end


--[[ ANIMATION FUNCTIONS ]]--
function sit(entity)

	ClearPedSecondaryTask(current_dog)
	local animdicstart
	local animnamestart
	local animdicend
	local animnameend

	animdicstart = "creatures@rottweiler@tricks@"
	animnamestart = "sit_enter"
	animdicend = "creatures@rottweiler@tricks@"
	animnameend = "sit_exit"
	

	if IsEntityPlayingAnim(entity, animdicstart, animnamestart, 3) then
		RequestAnimDict(animdicend)
		Citizen.Wait(100)
		TaskPlayAnim(current_dog, animdicend, animnameend, 1.0, -1, -1, 2, 0, 0, 0, 0)
		if HasEntityAnimFinished(current_dog, animdicend, animnameend, 3) then
			ClearPedSecondaryTask(current_dog)
		end
		animation_played = nil
		TriggerEvent("DoLongHudText","K9: Dog, Stehen!")
	else
		RequestAnimDict(animdicstart)
		Citizen.Wait(100)
		TaskPlayAnim(current_dog, animdicstart, animnamestart, 1.0, -1, -1, 2, 0, 0, 0, 0)
		animation_played = "sit"
		TriggerEvent("DoLongHudText","K9: Dog, Sit!")
	end

end

function laydown(entity)
	ClearPedSecondaryTask(current_dog)
	local animdicstart
	local animnamestart
	local animdicend
	local animnameend

	animdicstart = "creatures@rottweiler@move"
	animnamestart = "dying"
	animdicend = "creatures@rottweiler@move"
	animnameend = "dying"

	if IsEntityPlayingAnim(entity, animdicstart, animnamestart, 3) then
			RequestAnimDict(animdicend)
			Citizen.Wait(100)
		TaskPlayAnim(current_dog, animdicend, animnameend, 1.0, -1, -1, 2, 0, 0, 0, 0)
		if HasEntityAnimFinished(current_dog, animdicend, animnameend, 3) then
			ClearPedSecondaryTask(current_dog)
		end
		animation_played = nil
		TriggerEvent("DoLongHudText","K9: Dog, Up!")
	else
		RequestAnimDict(animdicstart)
		Citizen.Wait(100)
		TaskPlayAnim(current_dog, animdicstart, animnamestart, 1.0, -1, -1, 2, 0, 0, 0, 0)
		animation_played = "laydown"
		TriggerEvent("DoLongHudText","K9: Dog, Lay!")
	end

end

-- -1592533895

--[[ EXTRA FUNCTIONS ]]--
function CheckVehicleRestriction(vehicle)
	for i = 1, #VehicleList do

		if GetHashKey(VehicleList[i]) == GetEntityModel(vehicle) then
			return true
		end
	end
	return false
end

function CheckPedRestriction(ped)
	for i = 1, #PedList do
		if PedList[i] == GetEntityModel(ped) then
			return true
		end
	end
	return false
end



-------------------- K9 Death -----------------------------


Citizen.CreateThread(function()
    imDead = 0
    ragdol = 0
    while true do
        Wait(1)
        if IsEntityDead(current_dog) and current_dog ~= 0 then 

            SetPedToRagdoll(current_dog, 6000, 6000, 0, 0, 0, 0)

            SetEntityInvincible(current_dog, true)
            SetEntityHealth(current_dog, GetEntityMaxHealth(current_dog))
            
            Wait(3000)
            SetPedToRagdoll(current_dog, 6000, 6000, 0, 0, 0, 0)
            plyPos = GetEntityCoords(current_dog)
            Wait(500)

            if imDead == 0 then
                imDead = 1
                deathTimer()
            end
        elseif current_dog == 0 then
        	Citizen.Wait(3000)
        end
    end
end)


RegisterNetEvent('K9:disableAllActions')
AddEventHandler('K9:disableAllActions', function()
    SetPedToRagdoll(current_dog, 5000, 5000, 0, 0, 0, 0)
    Citizen.Wait(5000)

    while imDead == 1 do
        Citizen.Wait(1000)    
        SetPedToRagdoll(current_dog, 5000, 5000, 0, 0, 0, 0)

    end

end)

RegisterNetEvent('k9:doTimer')
AddEventHandler('k9:doTimer', function()
    while imDead == 1 do
        Citizen.Wait(0)

    	pedcoords = GetEntityCoords(PlayerPedId())
		dogcoords = GetEntityCoords(current_dog)
		distancecheck = #(pedcoords - dogcoords)	
		if distancecheck < 10 then
	        if IsControlJustPressed(1, 38) and distancecheck < 5 then
				releaseBody()
			end

	        tp =  GetOffsetFromEntityInWorldCoords(current_dog, 0.0, 0.0, 0.3)
	        DrawText3Ds(tp.x,tp.y,tp.z,"Press E to help dog up")
	    end
    end
end)

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

function deathTimer()
    thecount = 300
    TriggerEvent('k9:doTimer')
    while imDead == 1 and current_dog ~= 0 do
    	currentState = "D"
        Citizen.Wait(100)
        TriggerEvent('K9:disableAllActions')
        thecount = thecount - 0.1

        if thecount == 60 or thecount == 120 or thecount == 180 or thecount == 240 then
            TriggerEvent("civilian:alertPolice",100.0,"death",0)
        end
        --SetEntityHealth(current_dog, GetEntityMaxHealth(current_dog))
        if thecount < 0 then
            Citizen.Wait(0)    

			SetEntityAsMissionEntity(current_dog,false,true)
			DeleteEntity(current_dog)
			TriggerEvent("DoLongHudText","K9: Your dog has been transported to the police vet.")
			current_dog = nil
			thecount = 240
		    imDead = 0   
		    ragdol = 1
        end      
    end
end

function releaseBody()
    thecount = 240
    imDead = 0   
    ragdol = 1
    
	local model
	model = `a_c_shepherd`
	
	RequestModel(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(100)
	end	

	local plypos = GetOffsetFromEntityInWorldCoords(current_dog, 0.0, 0.0, 0.0)
	local plyhead = GetEntityHeading(current_dog)
	DeleteEntity(current_dog)
	local spawned_entity = CreatePed(GetPedType(model), model, plypos.x, plypos.y, plypos.z, plyhead, 1, 1)

	SetPedMaxHealth(spawned_entity, 9000) 
	SetEntityHealth(spawned_entity, 9000)
	SetPedDiesWhenInjured(spawned_entity, true)

	SetBlockingOfNonTemporaryEvents(spawned_entity, true)
	SetPedFleeAttributes(spawned_entity, 0, 0)
	current_dog = spawned_entity

	SetPedComponentVariation(current_dog,3,1,0,0)

	if dogTypeG  == 2 then
		SetPedComponentVariation(current_dog,3,1,1,0)
	end

	if dogTypeG  == 3 then
		SetPedComponentVariation(current_dog,3,1,2,0)
	end

	-- coyote
	local blip = AddBlipForEntity(current_dog)
	SetBlipAsFriendly(blip, true)
	SetBlipSprite(blip, 442)
	BeginTextCommandSetBlipName("STRING");
	AddTextComponentString(tostring("K9"))
	EndTextCommandSetBlipName(blip)
   
end
-- FiveM Heli Cam by mraes
-- Version 1.3 2017-06-12

-- config
local fov_max = 80.0
local fov_min = 10.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 5.0 -- camera zoom speed
local speed_lr = 3.0 -- speed by which the camera pans left-right 
local speed_ud = 3.0 -- speed by which the camera pans up-down
local toggle_helicam = 38 -- control id of the button by which to toggle the helicam mode. Default: INPUT_CONTEXT (E)
local toggle_vision = 25 -- control id to toggle vision mode. Default: INPUT_AIM (Right mouse btn)
local toggle_rappel = 154 -- control id to rappel out of the heli. Default: INPUT_DUCK (X)
local toggle_spotlight = 183 -- control id to toggle the front spotlight Default: INPUT_PhoneCameraGrid (G)
local toggle_lock_on = 22 -- control id to lock onto a vehicle with the camera. Default is INPUT_SPRINT (spacebar)
local rappeling = false
-- Script starts here
local helicam = false
local polmav_hash = `maverick2`
local fov = (fov_max+fov_min)*0.5
local vision_state = 0 -- 0 is normal, 1 is nightmode, 2 is thermal vision
local rappelingB = false

local JumpSoundPlayed = 340
local rappelSoundPlayed = 1001



RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
	toggle_helicam = table["heliCam"][1]
	toggle_vision = table["helivision"][1]
	toggle_rappel = table["helirappel"][1]
	toggle_spotlight = table["helispotlight"][1]
	toggle_lock_on = table["helilockon"][1]

end)

function rappelJumpSound()
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'jumpland', 0.3)
end

function rappelSound()
	if rappelSoundPlayed > 340 then
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, 'rapell', 0.2)
		rappelSoundPlayed = 0
	end
end

local curAnim = "none"
function endanimation()
    ClearPedSecondaryTask(PlayerPedId())
    curAnim = "none"
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

--anim("mp_fib_grab","rappel_jump_b",47)
local armed = false
function anim(dict,anim,key)

	if anim == curAnim then
		return
	end

	if anim == "rappel_jump_b" then
		rappelJumpSound()
	end
	
	curAnim = anim
    loadAnimDict( dict ) 
    TaskPlayAnim( PlayerPedId(), dict, anim, 1.0, 1.0, -1, key, 0, 0, 0, 0 )
end

function SetrappelType()
	ClearPedTasksImmediately(PlayerPedId())
	SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
	Citizen.Wait(300)
	local curw = GetSelectedPedWeapon(PlayerPedId())
	local w = `WEAPON_CARBINERIFLE`
	--if curw == w then
	--	TaskAimGunScripted(PlayerPedId(), `SCRIPTED_GUN_TASK_HANGING_UPSIDE_DOWN`, -1, -1);
	--	armed = true
	--else
		anim("mp_fib_grab","rappel_idle",47)
		armed = false
	--end
end
RegisterNetEvent('rappelBuilding')
AddEventHandler('rappelBuilding', function()

	local num = -1.0
	rappelingB = true

	local startCoords = GetEntityCoords(PlayerPedId())

	local curCoords = GetEntityCoords(PlayerPedId())
	local movecoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.5, 0.0)
	heliz = CreateObject(`prop_golf_ball`, movecoords, true, true, true)
	heliz2 = CreateObject(`prop_golf_ball`, movecoords, true, true, true)
	FreezeEntityPosition(heliz,true)
	FreezeEntityPosition(heliz2,true)

	helizCoords = GetEntityCoords(heliz)

	RopeLoadTextures()
	while not RopeAreTexturesLoaded() do
		Citizen.Wait(1)
	end


	Citizen.Wait(100)

	if GetEntityHeightAboveGround(heliz) < 4.0 then
		rappelingB = false
	else
		local curRope = AddRope(helizCoords,0.0,0.0,0.0,GetEntityHeightAboveGround(heliz),4,GetEntityHeightAboveGround(heliz),4.0,0.0,false,false,false,5.0,false,0)
--			
		helizCoords = GetEntityCoords(heliz)

		SetEntityVisible(heliz,false, 1)
		SetEntityVisible(heliz2,false, 1)
		SetrappelType()
			--mp_fib_grab enter_window
		while rappelingB do
			AttachRopeToEntity(curRope, heliz, helizCoords , 1)
			if GetFollowPedCamViewMode() == 4 or GetFollowVehicleCamViewMode() == 4 then
				SetFollowPedCamViewMode(0)
				SetFollowVehicleCamViewMode(0)
		    end
	        Citizen.Wait(1)
	        curCoords = GetEntityCoords(PlayerPedId())
	        rappelSoundPlayed = rappelSoundPlayed + 1

			if IsControlPressed(1,32) and GetEntityHeightAboveGround(PlayerPedId()) > 1.0 then
				movecoords = GetOffsetFromEntityInWorldCoords(heliz2, 0.0, 0.0, -0.025)
				SetEntityCoords(heliz2,movecoords)		
				rappelSound()
				if not armed then
					anim("mp_fib_grab","rappel_walk",47)
				end
			elseif IsControlPressed(1,8) and curCoords.z < startCoords.z then
				movecoords = GetOffsetFromEntityInWorldCoords(heliz2, 0.0, 0.0, 0.025)
				SetEntityCoords(heliz2,movecoords)				
				rappelSound()
				if not armed then
					anim("mp_fib_grab","rappel_walk",47)
				end
			elseif IsControlPressed(1,22) and GetEntityHeightAboveGround(PlayerPedId()) > 1.0 then
				movecoords = GetOffsetFromEntityInWorldCoords(heliz2, 0.0, 0.0, -0.1)
				SetEntityCoords(heliz2,movecoords)
				rappelSound()

				if not armed then
					anim("mp_fib_grab","rappel_idle",47)
			--		anim("mp_fib_grab","rappel_jump_b",47)
				end
			else
				if not armed then
					anim("mp_fib_grab","rappel_idle",47)
				end
			end


			AttachEntityToEntityPhysically(PlayerPedId(),heliz2, 1, 28422, 0.0, 0.0, 0.0, 0.0, 0.4, 0.0, 0.0, 0.0, GetEntityHeading(PlayerPedId()) + GetGameplayCamRelativeHeading(), 0.0, false, true, true, 1, true) 	
			
			if IsPedRagdoll(PlayerPedId()) then
				DetachEntity(PlayerPedId())
				rappelingB = false
			end

	    end
	    DeleteEntity(heliz2)
	    DeleteEntity(heliz)
	    DetachEntity(PlayerPedId())  
	    curCoords = GetEntityCoords(PlayerPedId())
	    zcheck = startCoords.z - curCoords.z
	    curAnim = "none"
	    if zcheck < 2 then
	    	SetEntityCoords(PlayerPedId(),startCoords)
	    	anim("mp_fib_grab","enter_window",47)
	    else
	    	anim("mp_fib_grab","enter_window",47)
	    end 
	    Citizen.Wait(1100) 
	    rappelJumpSound()
	 
	    ClearPedTasks(PlayerPedId())
    end
    DeleteEntity(heliz2)
    DeleteEntity(heliz)
    DeleteRope(curRope)
end)
DetachEntity(PlayerPedId())
function getSeatNumber(vehicle)
	myseat = -1
	for i = -1, 10 do
		if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
			myseat = i
		end
	end
	return myseat
end

RegisterNetEvent('rappelHeli')
AddEventHandler('rappelHeli', function(heli)

	rappeling = true

	while rappeling do
        Citizen.Wait(1)
 
    	if GetEntityHeightAboveGround(PlayerPedId()) < 3.0 then
    		ClearPedTasksImmediately(PlayerPedId())
    	--	FreezeEntityPosition(PlayerPedId(),false)
    		rappeling = false
    	end
    end

end)
function helirappel()
	if IsControlJustReleased(0, toggle_rappel) and rappeling then
	--	FreezeEntityPosition(PlayerPedId(),false)
		rappeling = false
		Citizen.Wait(1000)
	end
end
function standardrappel()
	if IsControlJustReleased(0, toggle_rappel) and not rappelingB then -- Initiate rappel
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
		TriggerEvent("rappelBuilding")
		Citizen.Wait(1000)
	end
	if IsControlJustReleased(0, toggle_rappel) and rappelingB then
		ClearPedTasksImmediately(PlayerPedId())
	--	FreezeEntityPosition(PlayerPedId(),false)
		rappelingB = false
		Citizen.Wait(1000)
	end
end



function isSwat()
	if `s_m_y_swat_01` == GetEntityModel(PlayerPedId()) then
		return true
	else
		return false
	end
end

job = "None"

--local myJob = exports["isPed"]:isPed("myJob")
RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(jobpassed, name, notify)
	job = jobpassed
    if not job then
        job = "None"
    end
end)


local dashcam = false
local bodycam = false
local pdVehicle = 0
RegisterNetEvent("dashcam:toggle")
AddEventHandler("dashcam:toggle", function()
	dashcam = not dashcam
end)

RegisterNetEvent("bodycam:toggle")
AddEventHandler("bodycam:toggle", function()
	bodycam = not bodycam
end)

RegisterNetEvent("dashcam:setVehicle")
AddEventHandler("dashcam:setVehicle", function()
	Citizen.Trace("Vehicle set to current.")

	pdVehicle = GetVehiclePedIsUsing(PlayerPedId())
	if not IsCalculatedCar(pdVehicle) then
		pdVehicle = 0
		TriggerEvent("DoShortHudText","Invalid Model.",2)
	else
		TriggerEvent("DoShortHudText","Dashcam Ready.",5)
	end
	Citizen.Trace(pdVehicle)
end)



local copVehicleList = { 
	[1] = { ["model"] = "pol1", ["height"] = 0.2, ["forward"] = 0.0 }, -- cvpi
	[2] = { ["model"] = "pol2", ["height"] = 0.2, ["forward"] = 0.0 }, -- cvpi
	[3] = { ["model"] = "pol3", ["height"] = 0.0, ["forward"] = 0.0 }, -- taurus
	[4] = { ["model"] = "pol5", ["height"] = 0.12, ["forward"] = 0.0 }, -- tahoe LB
	[5] = { ["model"] = "pol6", ["height"] = 0.08, ["forward"] = 0.0 }, -- tahoe ST
	[6] = { ["model"] = "pol9", ["height"] = 0.6, ["forward"] = 0.53 }, -- Truck
	[7] = { ["model"] = "pol7", ["height"] = 0.1, ["forward"] = 0.0 }, -- charger
}

function IsCalculatedCar()
	for i = 1, #copVehicleList do
		if GetEntityModel(pdVehicle) == GetHashKey(copVehicleList[i]["model"]) then
			return true
		end
	end
	return false
end

function CamAdjustment()
	for i = 1, #copVehicleList do
		if GetEntityModel(pdVehicle) == GetHashKey(copVehicleList[i]["model"]) then
			return i
		end
	end
	Citizen.Trace("BORKED")
end


Citizen.Trace(GetEntityModel(GetVehiclePedIsIn(PlayerPedId())))

Citizen.CreateThread(function()
	ClearTimecycleModifier()
	RenderScriptCams(false, false, 0, 1, 0)
	SetNightvision(false)
	SetSeethrough(false)
	RopeLoadTextures()
	while not RopeAreTexturesLoaded() do
		Citizen.Wait(1)
	end

	while true do
        Citizen.Wait(0)

        if IsPlayerInPolmav() then

			local lPed = PlayerPedId()
			local heli = GetVehiclePedIsIn(lPed)
		

			if IsControlJustReleased(0, toggle_helicam) and GetPedInVehicleSeat(heli, -1) ~= lPed then -- Toggle Helicam
				PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
				helicam = not helicam
			end
				
			if IsHeliHighEnough(heli) and isSwat() then	
				if IsControlJustReleased(0, toggle_rappel) and GetPedInVehicleSeat(heli, -1) ~= lPed then -- Initiate rappel
					Citizen.Trace("try to rappel")
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	        		TriggerEvent("rappelHeli")
	        		TaskRappelFromHeli(PlayerPedId(), 0)
				end
			end
			
			if IsControlJustReleased(0, toggle_spotlight) and GetPedInVehicleSeat(heli, -1) == lPed then
				spotlight_state = not spotlight_state
				TriggerServerEvent("heli:spotlight", spotlight_state)
				PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
			end
			
		else
			local inveh = IsPedInVehicle(PlayerPedId(),currentVehicle,false)
			if isSwat() and not inveh then
				if rappeling then
					helirappel()
				else
					standardrappel()
				end
			else
				Wait(100)
			end
		end


		if helicam then
			SetTimecycleModifier("heliGunCam")
			SetTimecycleModifierStrength(0.3)
			local scaleform = RequestScaleformMovie("HELI_CAM")
			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(0)
			end

			local lPed = PlayerPedId()
			local heli = GetVehiclePedIsIn(lPed)
			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
			AttachCamToEntity(cam, heli, 0.0,0.0,-1.5, true)
			SetCamRot(cam, 0.0,0.0,GetEntityHeading(heli))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)
			PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
			PushScaleformMovieFunctionParameterInt(1) -- 0 for nothing, 1 for LSPD logo
			PopScaleformMovieFunctionVoid()
			local locked_on_vehicle = nil
			while helicam and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == heli) and IsHeliHighEnough(heli) do
				if IsControlJustReleased(0, toggle_helicam) then -- Toggle Helicam
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					helicam = false
					Citizen.Wait(100)
				end
				if IsControlJustPressed(0, toggle_vision) then
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					ChangeVision()
				end
				local camcoords = GetCamCoord(cam)
				local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
				DrawSpotLight(camcoords, forward_vector, 200, 200, 205, 300.0, 15.0, 0.0, 8.0, 1.0)

				if locked_on_vehicle then
					if DoesEntityExist(locked_on_vehicle) then
						PointCamAtEntity(cam, locked_on_vehicle, 0.0, 0.0, 0.0, true)
						RenderVehicleInfo(locked_on_vehicle)
						if IsControlJustPressed(0, toggle_lock_on) or not HasEntityClearLosToEntity( GetPlayerPed( -1 ), locked_on_vehicle, 17 ) then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							locked_on_vehicle = nil
							local rot = GetCamRot(cam, 2) -- All this because I can't seem to get the camera unlocked from the entity
							local fov = GetCamFov(cam)
							local old cam = cam
							DestroyCam(old_cam, false)
							cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
							AttachCamToEntity(cam, heli, 0.0,0.0,-1.5, true)
							SetCamRot(cam, rot, 2)
							SetCamFov(cam, fov)
							RenderScriptCams(true, false, 0, 1, 0)
						end
					else
						locked_on_vehicle = nil -- Cam will auto unlock when entity doesn't exist anyway
					end
				else
					local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
					CheckInputRotation(cam, zoomvalue)
					local vehicle_detected = GetVehicleInView(cam)
					if DoesEntityExist(vehicle_detected) then
						RenderVehicleInfo(vehicle_detected)
						if IsControlJustPressed(0, toggle_lock_on) then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							locked_on_vehicle = vehicle_detected
						end
					end
				end
				HandleZoom(cam)
				HideHUDThisFrame()
				PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
				PushScaleformMovieFunctionParameterFloat(GetEntityCoords(heli).z)
				PushScaleformMovieFunctionParameterFloat(zoomvalue)
				PushScaleformMovieFunctionParameterFloat(GetCamRot(cam, 2).z)
				PopScaleformMovieFunctionVoid()
				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				Citizen.Wait(0)
			end
			helicam = false
			ClearTimecycleModifier()
			fov = (fov_max+fov_min)*0.5 -- reset to starting zoom level
			RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera
			SetScaleformMovieAsNoLongerNeeded(scaleform) -- Cleanly release the scaleform
			DestroyCam(cam, false)
			SetNightvision(false)
			SetSeethrough(false)
		end
	end
end)

RegisterNetEvent('heli:spotlight')
AddEventHandler('heli:spotlight', function(serverID, state)
	if DoesPlayerExist(serverID) then
		local heli = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(serverID)), false)
		SetVehicleSearchlight(heli, state, false)
		Citizen.Trace("Set heli light state to "..tostring(state).." for serverID: "..serverID)
	end
end)

function IsPlayerInPolmav()
	local lPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(lPed)
	return IsVehicleModel(vehicle, polmav_hash)
end

function IsHeliHighEnough(heli)
	return GetEntityHeightAboveGround(heli) > 5.5
end

function ChangeVision()
	if vision_state == 0 then
		SetNightvision(true)
		vision_state = 1
	elseif vision_state == 1 then
		SetNightvision(false)
		SetSeethrough(true)
		vision_state = 2
	else
		SetSeethrough(false)
		vision_state = 0
	end
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(19) -- weapon wheel
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5) -- Clamping at top (cant see top of heli) and at bottom (doesn't glitch out in -90deg)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	if IsControlJustPressed(0,241) then -- Scrollup
		fov = math.max(fov - zoomspeed, fov_min)
	end
	if IsControlJustPressed(0,242) then
		fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown		
	end
	local current_fov = GetCamFov(cam)
	if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
		fov = current_fov
	end
	SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
end

function GetVehicleInView(cam)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
	--DrawLine(coords, coords+(forward_vector*100.0), 255,0,0,255) -- debug line to show LOS of cam
	local rayhandle = CastRayPointToPoint(coords, coords+(forward_vector*200.0), 10, GetVehiclePedIsIn(PlayerPedId()), 0)
	local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
	if entityHit>0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

function RenderVehicleInfo(vehicle)
	local model = GetEntityModel(vehicle)
	local vehname = GetLabelText(GetDisplayNameFromVehicleModel(model))
	local licenseplate = GetVehicleNumberPlateText(vehicle)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, 0.55)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString("Model: "..vehname.."\nPlate: "..licenseplate)
	DrawText(0.45, 0.9)
end

-- function HandleSpotlight(cam)
-- if IsControlJustPressed(0, toggle_spotlight) then
	-- PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	-- spotlight_state = not spotlight_state
-- end
-- if spotlight_state then
	-- local rotation = GetCamRot(cam, 2)
	-- local forward_vector = RotAnglesToVec(rotation)
	-- local camcoords = GetCamCoord(cam)
	-- DrawSpotLight(camcoords, forward_vector, 255, 255, 255, 300.0, 10.0, 0.0, 2.0, 1.0)
-- end
-- end

function RotAnglesToVec(rot) -- input vector3
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end
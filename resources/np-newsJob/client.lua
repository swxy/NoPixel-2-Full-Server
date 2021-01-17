local holdingCam = false
local usingCam = false
local holdingMic = false
local usingMic = false
local camModel = "prop_v_cam_01"
local camanimDict = "missfinale_c2mcs_1"
local camanimName = "fin_c2_mcs_1_camman"
local micModel = "p_ing_microphonel_01"
local micanimDict = "missheistdocksprep1hold_cellphone"
local micanimName = "hold_cellphone"
local mic_object = nil
local cam_object = nil
local UI = { 
	x =  0.000 ,
	y = -0.001 ,
}

local currentHolding = "camera"
local newscamera = false
local movcamera = false

local holdingBoom = false
local usingBoom = false

---------------------------------------------------------------------------
-- Toggling Cam --
---------------------------------------------------------------------------
function ToggleCam()
    if not holdingCam then
    	TriggerEvent("phone:currentNewsState",true)
        RequestModel(GetHashKey(camModel))
        while not HasModelLoaded(GetHashKey(camModel)) do
            Citizen.Wait(100)
        end
		
        local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
        local camspawned = CreateObject(GetHashKey(camModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
        cam_object = camspawned
        AttachEntityToEntity(camspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
		while not HasAnimDictLoaded(camanimDict) do
			RequestAnimDict(camanimDict)
			Citizen.Wait(100)
		end
		--SetEntityAsMissionEntity(camspawned,false,true)
        TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
        TaskPlayAnim(GetPlayerPed(PlayerId()), camanimDict, camanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
        holdingCam = true
		DisplayNotification("To enter News cam press ~INPUT_PICKUP~ \nTo Enter Movie Cam press ~INPUT_INTERACTION_MENU~")
    else
        removeCamera()
    end
end

Citizen.CreateThread(function()

	while not HasAnimDictLoaded(camanimDict) do
		RequestAnimDict(camanimDict)
		Citizen.Wait(100)
	end

	while true do
		local hold = false
		Citizen.Wait(0)
		if holdingCam then
			hold = true
			if not IsEntityPlayingAnim(PlayerPedId(), camanimDict, camanimName, 3) then
				while not HasAnimDictLoaded(camanimDict) do
					RequestAnimDict(camanimDict)
					Citizen.Wait(100)
				end
				TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
				TaskPlayAnim(GetPlayerPed(PlayerId()), camanimDict, camanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
			end
				
			DisablePlayerFiring(PlayerId(), true)
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0, 44,  true) -- INPUT_COVER
			DisableControlAction(0,37,true) -- INPUT_SELECT_WEAPON
			TriggerEvent("actionbar:setEmptyHanded")
		end
		if not hold then
			Wait(900)
		end
	end
	
end)

function removeCamera()
	ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
    DetachEntity(cam_object, 1, 1)
    DeleteEntity(cam_object)
    cam_object = nil
    holdingCam = false
    usingCam = false
    newscamera = false
	movcamera = false
    TriggerEvent("phone:currentNewsState",false)

end

function removeMic()
	TriggerEvent("disabledWeapons",false)
    TriggerEvent('news:HoldingState',false)
    ClearPedTasks(PlayerPedId())
    TriggerEvent("destroyProp")
    holdingMic = false
    usingMic = false
    TriggerEvent("phone:currentNewsState",false)
end

function removeBoom()

	TriggerEvent("disabledWeapons",false)
    TriggerEvent('news:HoldingState',false)
    ClearPedTasks(PlayerPedId())
    TriggerEvent("destroyProp")
    holdingBoom = false
    usingBoom = false
    TriggerEvent("phone:currentNewsState",false)
end


RegisterNetEvent('camera:setCamera')
AddEventHandler('camera:setCamera', function()
	currentHolding = "camera"
end)

RegisterNetEvent('camera:setMic')
AddEventHandler('camera:setMic', function()
	currentHolding = "handMic"
end)

RegisterNetEvent('camera:setBoom')
AddEventHandler('camera:setBoom', function()
	currentHolding = "boomarm"
end)


RegisterNetEvent('event:control:newsJob')
AddEventHandler('event:control:newsJob', function(useID)
	if useID == 1 then
		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if exports["np-base"]:getModule("LocalPlayer"):getVar("job") == "news" and not exports["isPed"]:isPed("disabled") and not isInVeh then
			if currentHolding == "camera" then
				removeBoom()
				removeMic()
				ToggleCam()
			elseif currentHolding == "handMic" then
				removeBoom()
				removeCamera()
				ToggleMic()
			elseif currentHolding == "boomarm" then
				removeMic()
				removeCamera()
				ToggleBoom()
			end
		end
	elseif useID == 2 and not movcamera then

		if newscamera then
			PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
			newscamera = false
		else
			if holdingCam then newsCam() end
		end

	elseif useID == 3 and not newscamera and holdingCam then
		if movcamera then
			PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
			movcamera = false
		else
			if holdingCam then MovieCam() end
		end
	end
end)

local myJob = ""
Citizen.CreateThread(function()
	while true do
		myJob = exports["np-base"]:getModule("LocalPlayer"):getVar("job")
		Citizen.Wait(50000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local isInVeh = IsPedInAnyVehicle(PlayerPedId(), false)
		if isInVeh then
			if holdingCam then
	  			removeCamera()
	  		elseif holdingMic then
	  			removeMic()
	  		elseif holdingBoom then
	  			removeBoom()
	  		end
	  	end
		if not myJob == "news" then
	    	Citizen.Wait(5000)
	    	if currentHolding == "camera" or currentHolding == "handMic" or currentHolding == "boomarm" then
				removeCamera()
				removeMic()
				removeBoom()
				currentHolding = "none"
			end
	    end
	end
end)

---------------------------------------------------------------------------
-- Cam Functions --
---------------------------------------------------------------------------

local fov_max = 70.0
local fov_min = 5.0
local zoomspeed = 10.0
local speed_lr = 8.0
local speed_ud = 8.0

local camera = false
local fov = (fov_max+fov_min)*0.5

---------------------------------------------------------------------------
-- Movie Cam --
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- News Cam --
---------------------------------------------------------------------------
function MovieCam()

	movcamera = true
	SetTimecycleModifier("default")

	SetTimecycleModifierStrength(0.3)
	
	local scaleform = RequestScaleformMovie("security_camera")

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(10)
	end


	local lPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(lPed)
	local cam1 = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

	AttachCamToEntity(cam1, lPed, 0.0,0.6,0.75, true)
	SetCamRot(cam1, 2.0,1.0,GetEntityHeading(lPed))
	SetCamFov(cam1, fov)
	RenderScriptCams(true, false, 0, 1, 0)
	PushScaleformMovieFunction(scaleform, "security_camera")
	PopScaleformMovieFunctionVoid()

	while movcamera and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) and true do
		SetEntityRotation(lPed, 0, 0, new_z,2, true)

		local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
		CheckInputRotation(cam1, zoomvalue)

		HandleZoom(cam1)
		HideHUDThisFrame()
		
		local camHeading = GetGameplayCamRelativeHeading()
		local camPitch = GetGameplayCamRelativePitch()
		if camPitch < -70.0 then
			camPitch = -70.0
		elseif camPitch > 42.0 then
			camPitch = 42.0
		end
		camPitch = (camPitch + 70.0) / 112.0
		
		if camHeading < -180.0 then
			camHeading = -180.0
		elseif camHeading > 180.0 then
			camHeading = 180.0
		end
		camHeading = (camHeading + 180.0) / 360.0
		
		Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Pitch", camPitch)
		Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Heading", camHeading * -1.0 + 1.0)
		
		Citizen.Wait(1)
	end

	movcamera = false
	ClearTimecycleModifier()
	fov = (fov_max+fov_min)*0.5
	RenderScriptCams(false, false, 0, 1, 0)
	SetScaleformMovieAsNoLongerNeeded(scaleform)
	DestroyCam(cam1, false)
	SetNightvision(false)
	SetSeethrough(false)
end


function newsCam()

	newscamera = true
	SetTimecycleModifier("default")

	SetTimecycleModifierStrength(0.3)
	
	local scaleform = RequestScaleformMovie("security_camera")
	local scaleform2 = RequestScaleformMovie("breaking_news")


	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(10)
	end
	while not HasScaleformMovieLoaded(scaleform2) do
		Citizen.Wait(10)
	end


	local lPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(lPed)
	local cam2 = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

	AttachCamToEntity(cam2, lPed, 0.0,0.6,0.75, true)
	SetCamRot(cam2, 2.0,1.0,GetEntityHeading(lPed))
	SetCamFov(cam2, fov)
	RenderScriptCams(true, false, 0, 1, 0)
	--PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
	PushScaleformMovieFunction(scaleform2, "breaking_news")
	PopScaleformMovieFunctionVoid()

	while newscamera and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) and true do
		
		SetEntityRotation(lPed, 0, 0, new_z,2, true)
			
		local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
		CheckInputRotation(cam2, zoomvalue)

		HandleZoom(cam2)
		HideHUDThisFrame()


		DrawScaleformMovie(scaleform2, 0.5, 0.63, 1.0, 1.0, 255, 255, 255, 255)

		
		local camHeading = GetGameplayCamRelativeHeading()
		local camPitch = GetGameplayCamRelativePitch()
		if camPitch < -70.0 then
			camPitch = -70.0
		elseif camPitch > 42.0 then
			camPitch = 42.0
		end
		camPitch = (camPitch + 70.0) / 112.0
		
		if camHeading < -180.0 then
			camHeading = -180.0
		elseif camHeading > 180.0 then
			camHeading = 180.0
		end
		camHeading = (camHeading + 180.0) / 360.0
		
		Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Pitch", camPitch)
		Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Heading", camHeading * -1.0 + 1.0)
		
		Citizen.Wait(1)
	end

	newscamera = false
	ClearTimecycleModifier()
	fov = (fov_max+fov_min)*0.5
	RenderScriptCams(false, false, 0, 1, 0)
	SetScaleformMovieAsNoLongerNeeded(scaleform)
	DestroyCam(cam2, false)
	SetNightvision(false)
	SetSeethrough(false)

end


---------------------------------------------------------------------------
-- Events --
---------------------------------------------------------------------------

-- Activate camera
RegisterNetEvent('camera:Activate')
AddEventHandler('camera:Activate', function()
	camera = not camera
end)

--FUNCTIONS--
function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1)
	HideHudComponentThisFrame(2)
	HideHudComponentThisFrame(3)
	HideHudComponentThisFrame(4)
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13)
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
	HideHudComponentThisFrame(19)
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	local lPed = PlayerPedId()
	if not ( IsPedSittingInAnyVehicle( lPed ) ) then

		if IsControlJustPressed(0,241) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	else
		if IsControlJustPressed(0,17) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,16) then
			fov = math.min(fov + zoomspeed, fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	end
end

--
---------------------------------------------------------------------------
-- Toggling Mic --
---------------------------------------------------------------------------
function ToggleMic()
    if not holdingMic then
    	TriggerEvent("phone:currentNewsState",true)
        TriggerEvent("disabledWeapons",true)
        TriggerEvent('news:HoldingState',true)
        TriggerEvent("attachItem","tvmic01")
        RequestAnimDict("move_weapon@pistol@copc")
        TaskPlayAnim(PlayerPedId(),"move_weapon@pistol@copc","idle",2.0, -8, 180,49, 0, 0, 0, 0)
        Wait(100)
        TaskPlayAnim(PlayerPedId(),"move_weapon@pistol@copc","idle",2.0, -8, 1800000,49, 0, 0, 0, 0)
        holdingMic = true
    else
    	removeMic()
    end
end

function ToggleBoom()
    if not holdingBoom then
    	TriggerEvent("phone:currentNewsState",true)
        TriggerEvent("disabledWeapons",true)
        TriggerEvent('news:HoldingState',true)
        TriggerEvent("attachItem","boomMIKE01")
        RequestAnimDict("missfra1")
        TaskPlayAnim(PlayerPedId(),"missfra1","mcs2_crew_idle_m_boom",2.0, -8, 180,49, 0, 0, 0, 0)
        Wait(100)
        TaskPlayAnim(PlayerPedId(),"missfra1","mcs2_crew_idle_m_boom",2.0, -8, 1800000,49, 0, 0, 0, 0)
        holdingBoom = true
    else
    	removeBoom()
    end
end


function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

function Breaking(text)
		SetTextColour(255, 255, 255, 255)
		SetTextFont(8)
		SetTextScale(1.2, 1.2)
		SetTextWrap(0.0, 1.0)
		SetTextCentre(false)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 205)
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(0.2, 0.85)
end

function Notification(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0, 1)
end

function DisplayNotification(string)
	SetTextComponentFormat("STRING")
	AddTextComponentString(string)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

---------------------------------------------------------------------------
-- Lighting --
---------------------------------------------------------------------------

local currentArray = {}
local currentLight = nil

RegisterNetEvent("news:light")
AddEventHandler("news:light", function(r,g,b)
  local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.15, -1.0)
  local heading = GetEntityHeading(PlayerPedId())
  currentLight = CreateObject(`prop_studio_light_02`,pos,true,false,false)
  SetEntityHeading(currentLight,heading+180)
  Wait(900)
  local id = ObjToNet(currentLight)

  colorr = 200
  colorg = 200
  colorb = 200
  local rgb = {colorr,colorg,colorb}
  if r ~= nil then
    rgb = {r,g,b}
  end
  TriggerServerEvent('light:addNews',rgb,tonumber(id),{pos.x,pos.y,pos.z})
end)


RegisterCommand('light', function(source, args)
TriggerEvent('news:light', args[1], args[2], args[3])
end)

RegisterCommand('removeLight', function(source, args)
	TriggerServerEvent('light:removeLight')
end)

RegisterNetEvent("news:removeLight")
AddEventHandler("news:removeLight", function(object)
  DeleteEntity(NetToObj(object))
end)

RegisterNetEvent("news:updateLights")
AddEventHandler("news:updateLights", function(LightArray)
 currentArray = LightArray
end)


Citizen.CreateThread(function()
  local hit = true
    while true do
    	local hasFound = false
	    Citizen.Wait(0)
	    if currentArray ~= nil and currentLight ~= nil then
		    if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(currentLight)) > 100 then
		      TriggerServerEvent('light:removeLight')
		      currentLight = nil
		    end
			for i,v in ipairs(currentArray) do
				 if #(GetEntityCoords(PlayerPedId()) - vector3(v.pos[1],v.pos[2],v.pos[3])) < 90 then
					if v.Object ~= 0 then
						if NetworkDoesNetworkIdExist(v.Object) then 
							hasFound = true
							local object = NetToObj(v.Object)
							local spotlightObject = GetEntityHeading(object) + 85

							if spotlightObject < 0 then
							spotlightObject = 360.0 + spotlightObject
							end
							local x,y = quickmafs( spotlightObject )
							DrawSpotLight(GetOffsetFromEntityInWorldCoords(object,0.0,1.0,2.0), x, y, -0.0043, v.rgb[1],v.rgb[2],v.rgb[3], 40.0, 20.0, 10.0, 35.0, 30.5)
						end
					end
				end
			end
		end
		if not hasFound then
			Wait(4000)
		end
    end
end)

function quickmafs(dir)
  local x = 0.0
  local y = 0.0
  local dir = dir
  if dir >= 0.0 and dir <= 90.0 then
    local factor = (dir/9.2) / 10
    x = -1.0 + factor
    y = 0.0 - factor
  end

  if dir > 90.0 and dir <= 180.0 then
    dirp = dir - 90.0
    local factor = (dirp/9.2) / 10
    x = 0.0 + factor
    y = -1.0 + factor
  end

  if dir > 180.0 and dir <= 270.0 then
    dirp = dir - 180.0
    local factor = (dirp/9.2) / 10
    x = 1.0 - factor
    y = 0.0 + factor
  end

  if dir > 270.0 and dir <= 360.0 then
    dirp = dir - 270.0
    local factor = (dirp/9.2) / 10  
    x = 0.0 - factor
    y = 1.0 - factor
  end
  return x,y
end

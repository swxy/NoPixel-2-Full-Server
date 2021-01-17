

local isInCamera = false

local currentObject = ""
local objectIndex = 1
local object = nil
local currentHeading = 0.0
local pos = {}
local moveWeight = 0.1
local buildMode = "Movement"
local secondaryMode = "Local"

local maxObjects = 20
local currentAmount = 0
local cost = 0
local rotation = {}

local showInfo = true
local showControls = true
local startHeading = 0  
local startPitch = 0
local form = nil
local CurrentPlacedObjects = {}
local loadedObjects = {}
local selectedObject = 0

local props = {
[1] = {"prop_aerial_01a", 900},
[2] = {"prop_aerial_01b", 900},
[3] = {"prop_aerial_01c", 900},
[4] = {"prop_aerial_01d", 900},
[5] = {"prop_afsign_amun", 900},
[6] = {"prop_afsign_vbike", 900},
[7] = {"prop_agave_01", 900},
[8] = {"prop_agave_02", 900},
[9] = {"prop_aiprort_sign_01", 900},
[10] = {"prop_aiprort_sign_02", 900},
[11] = {"prop_aircon_l_01", 900},
[12] = {"prop_aircon_l_02", 900},
[13] = {"prop_aircon_l_03", 900},
[14] = {"prop_aircon_l_04", 900},
[15] = {"prop_aircon_m_09", 900},
[16] = {"prop_aircon_s_01a", 900},
[17] = {"prop_aircon_s_02a", 900},
[18] = {"prop_aircon_s_02b", 900},
[19] = {"prop_aircon_s_03a", 900},
[20] = {"prop_aircon_s_03b", 900},
[21] = {"prop_aircon_s_04a", 900},
[22] = {"prop_aircon_s_05a", 900},
[23] = {"prop_aircon_s_06a", 900},
[24] = {"prop_aircon_s_07a", 900},
[25] = {"prop_aircon_s_07b", 900},
[26] = {"prop_airhockey_01", 900},
[27] = {"prop_air_bagloader", 900},
[28] = {"prop_air_bagloader2", 900},
[29] = {"prop_air_barrier", 900},
[30] = {"prop_air_bench_01", 900},
}

RegisterNetEvent('furniture:Start')
AddEventHandler('furniture:Start', function()
	form = setupScaleform("instructional_buttons")
	isInCamera = true
	createObject()
end)

Citizen.CreateThread(function()
	currentObject = props[1][1]

	while true do
		if isInCamera then
			if buildMode == "Edit" then
				local pos = GetEntityCoords(loadedObjects[selectedObject])
				DrawMarker(1, pos.x, pos.y, pos.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 2.0, 255, 255, 0, 75, 0, 0, 2, 0, 0, 0, 0)
			end
			renderText()	
			DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)
			if(IsControlJustPressed(1,82)) then
				if buildMode == "Movement" or buildMode == "Roate" then
					nextObject()
				else
					selectObjectNext()
				end
			end
			if(IsControlJustPressed(1,244)) then
				if buildMode == "Movement" or buildMode == "Roate" then
					backObject()
				else
					selectObjectBack()
				end
			end

			if(IsControlJustPressed(1,74)) then
				stopFuniture()
			end

			if(IsControlJustPressed(1,29)) then
				centerObject()
			end

			if(IsControlPressed(1,39)) and IsControlPressed(1,36) then
				if moveWeight < 6.0 then
					moveWeight = moveWeight + 0.001
				end
			end
			
			if(IsControlPressed(1,40)) and IsControlPressed(1,36) then
				if moveWeight >= 0.002 then
					moveWeight = moveWeight - 0.001
				end
				if moveWeight < 0.002 then moveWeight = 0.002 end
			end

			if(IsControlJustPressed(1,213)) and not IsControlPressed(1,36) then -- home change mode
				SetEntityCollision(loadedObjects[selectedObject],true,true)
				SetEntityAlpha(loadedObjects[selectedObject], 255, false)
				if buildMode == "Movement" then
					buildMode = "Roate"
				elseif buildMode == "Roate" then

					DeleteEntity(object)
					buildMode = "Edit"
				elseif buildMode == "Edit" then
					createObject()
					buildMode = "Movement"
				end
			end

			if(IsControlPressed(1,36)) and (IsControlJustPressed(1,213)) then -- change secondary
				if secondaryMode == "Local" then
					secondaryMode = "World"
				else
					secondaryMode = "Local"
				end
			end

			if(IsControlJustPressed(1,10)) then -- page up while in movement toggels Build Info
				if buildMode == "Movement" then
					showInfo = not showInfo
				end
			end

			if(IsControlJustPressed(1,11)) then -- page down while in movement toggels Controls
				if buildMode == "Movement" then
					showControls = not showControls
				end
			end

			if(IsControlJustPressed(1,18)) then -- Enter , for confirming Object
				if buildMode == "Movement" or buildMode == "Roate" then
					if canPlace() then
						placeObject()
					end
				end
			end

			--- left / right 

			if(IsControlPressed(1,108)) and not IsControlPressed(1,36) and not IsControlPressed(1,21) then -- left
				if buildMode == "Movement" then
					MoveObject("l")
				elseif buildMode == "Roate" then
					RotateObject("yl")
				end
			end


			if(IsControlPressed(1,107)) and not IsControlPressed(1,36)  and not IsControlPressed(1,21) then -- right
				if buildMode == "Movement" then
					MoveObject("r")
				elseif buildMode == "Roate" then
					RotateObject("yr")
				end
			end

			if(IsControlPressed(1,61)) and not IsControlPressed(1,36) and not IsControlPressed(1,21) then -- front
				if buildMode == "Movement" then
					MoveObject("f")
				elseif buildMode == "Roate" then
					RotateObject("pl")
				end
			end


			if(IsControlPressed(1,60)) and not IsControlPressed(1,36) and not IsControlPressed(1,21) then -- Back
				if buildMode == "Movement" then
					MoveObject("b")
				elseif buildMode == "Roate" then
					RotateObject("pr")
				end
			end

			if(IsControlPressed(1,117)) and not IsControlPressed(1,36)  and not IsControlPressed(1,21) then -- simple heading left
				if buildMode == "Movement" then
					MoveObject("u")
				elseif buildMode == "Roate" then
					RotateObject("rl")
				end
				
			end


			if(IsControlPressed(1,118)) and not IsControlPressed(1,36)  and not IsControlPressed(1,21) then -- simple Heading Right
				if buildMode == "Movement" then
					MoveObject("d")
				elseif buildMode == "Roate" then
					RotateObject("rr")
				end
			end

			if IsControlJustPressed(0, 177) and buildMode == "Movement" then

				local camPitch = GetGameplayCamRelativePitch()
				if camPitch < -70.0 then
					camPitch = -70.0
				elseif camPitch > 42.0 then
					camPitch = 42.0
				end
				startPitch = (camPitch + 70.0) / 112.0

				local camHeading = GetGameplayCamRelativeHeading()
				
				if camHeading < -180.0 then
					camHeading = -180.0
				elseif camHeading > 180.0 then
					camHeading = 180.0
				end
				startHeading = (camHeading + 180.0) / 360.0
			end

			if IsControlJustPressed(0,241) and buildMode == "Movement" then
				local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.0, 0.0)
				local pos2 = GetEntityCoords(object)
				local something = {}

				if pos.y > pos2.y then  
					something = GetOffsetFromEntityInWorldCoords(object,0.0, -moveWeight, 0.0)
				else
					something = GetOffsetFromEntityInWorldCoords(object,0.0, moveWeight, 0.0)
				end

				SetEntityCoords(object,something)
			end
			if IsControlJustPressed(0,242) and buildMode == "Movement" then
				local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.0, 0.0)
				local pos2 = GetEntityCoords(object)
				local something = {}

				if pos.y > pos2.y then  
					something = GetOffsetFromEntityInWorldCoords(object,0.0, moveWeight, 0.0)
				else
					something = GetOffsetFromEntityInWorldCoords(object,0.0, -moveWeight, 0.0)
				end

				SetEntityCoords(object,something)
			end

			Citizen.Wait(1)
		else
			Citizen.Wait(900)
		end
	end
end)




Citizen.CreateThread(function()
	while true do
		if IsControlPressed(0, 177) and buildMode == "Movement" then
			if isInCamera then
				local something = {}
				local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.0, 0.0)
				local pos2 = GetEntityCoords(object)

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
				
				if startHeading > camHeading+0.002 then
					if pos.y < pos2.y then  
						something = GetOffsetFromEntityInWorldCoords(object, 0.04, 0.0, 0.0)
					else
						something = GetOffsetFromEntityInWorldCoords(object, -0.04, 0.0, 0.0)
					end
					SetEntityCoords(object,something)
					startHeading = camHeading
				elseif startHeading < camHeading-0.002 then
					if pos.y < pos2.y then  
						something = GetOffsetFromEntityInWorldCoords(object, -0.04, 0.0, 0.0)
					else
						something = GetOffsetFromEntityInWorldCoords(object, 0.04, 0.0, 0.0)
					end
					
					SetEntityCoords(object,something)
					startHeading = camHeading
				end

				if startPitch > camPitch+0.002 then
					local something = GetOffsetFromEntityInWorldCoords(object, 0.0, 0.0, - 0.04)
					SetEntityCoords(object,something)
					startPitch = camPitch
				elseif startPitch < camPitch-0.002 then
					local something = GetOffsetFromEntityInWorldCoords(object, 0.0, 0.0,  0.04)
					SetEntityCoords(object,something)
					startPitch = camPitch
				end

				Citizen.Wait(1)
			else
				Citizen.Wait(900)
			end
		else
			Citizen.Wait(900)
		end
	end
end)


function selectObjectNext()

	SetEntityCollision(loadedObjects[selectedObject],true,true)
	SetEntityAlpha(loadedObjects[selectedObject], 255, false)
	if selectedObject == 0 then selectedObject = 1 else selectedObject = selectedObject +1 end
	if selectedObject > #loadedObjects then selectedObject = 1 end
	SetEntityCollision(loadedObjects[selectedObject],false,false)
	SetEntityAlpha(loadedObjects[selectedObject], 195, false)
end

function selectObjectBack()
	SetEntityCollision(loadedObjects[selectedObject],true,true)
	SetEntityAlpha(loadedObjects[selectedObject], 255, false)
	if selectedObject == 0 then selectedObject = 1 else selectedObject = selectedObject -1 end
	if selectedObject < 1 then selectedObject = #loadedObjects end
	SetEntityCollision(loadedObjects[selectedObject],false,false)
	SetEntityAlpha(loadedObjects[selectedObject], 195, false)
end

function placeObject()
	local insert = {["name"] = currentObject , ["pos"] = GetOffsetFromEntityInWorldCoords(object,0.0,0.0,0.0), ["rot"] = GetEntityRotation(object,2)}
	CurrentPlacedObjects[#CurrentPlacedObjects+1]=insert
	palceCurrentObjects()
end

function canPlace()
	
	for i,v in ipairs(CurrentPlacedObjects) do
		local getDist = #(vector3(v.pos.x,v.pos.y,v.pos.z) - GetEntityCoords(object))
		if getDist < 0.2 then 
			return false
		end
	end

	return true
end

function getPrice(name)
	for i,v in ipairs(props) do
		if v[1] == name then
			return v[2]
		end
	end

end

function palceCurrentObjects()
	cost = 0
	for i,v in ipairs(loadedObjects) do
		DeleteEntity(v)
	end
	loadedObjects = {}
	for i,v in ipairs(CurrentPlacedObjects) do
		cost = cost + getPrice(v.name)
		RequestModel(GetHashKey(v.name))
		while not HasModelLoaded(GetHashKey(v.name)) do
			Citizen.Wait(1)
		end

		local place = CreateObject(GetHashKey(v.name), v.pos.x, v.pos.y, v.pos.z, true, false, false)
		SetEntityRotation(place,v.rot.x,v.rot.y,v.rot.z,2,1)
		FreezeEntityPosition(place, true)
		SetModelAsNoLongerNeeded(GetHashKey(v.name))
		loadedObjects[#loadedObjects+1]=place
	end

	currentAmount = #CurrentPlacedObjects
end
		
function RotateObject(direction)
	roatation = GetEntityRotation(object,2)
	if direction == "yl" then
		SetEntityRotation(object,roatation.x,roatation.y,roatation.z+(moveWeight*3),2,1)
	elseif direction == "yr" then
		SetEntityRotation(object,roatation.x,roatation.y,roatation.z-(moveWeight*3),2,1)
	elseif direction == "rl" then
		SetEntityRotation(object,roatation.x,roatation.y+(moveWeight*3),roatation.z,2,1)
	elseif direction == "rr" then
		SetEntityRotation(object,roatation.x,roatation.y-(moveWeight*3),roatation.z,2,1)
	elseif direction == "pl" then
		SetEntityRotation(object,roatation.x+(moveWeight*3),roatation.y,roatation.z,2,1)
	elseif direction == "pr" then
		SetEntityRotation(object,roatation.x-(moveWeight*3),roatation.y,roatation.z,2,1)
	end
end

function MoveObject(direction)

	if direction == "f" then
		if secondaryMode == "Local" then
			pos = GetOffsetFromEntityInWorldCoords(object, moveWeight, 0.0, 0.0)
			SetEntityCoords(object,pos.x,pos.y,pos.z)
		else
			pos = GetOffsetFromEntityInWorldCoords(object,0.0, 0.0, 0.0)
			SetEntityCoords(object,pos.x+moveWeight,pos.y,pos.z)
		end
	elseif direction == "b" then
		if secondaryMode == "Local" then
			pos = GetOffsetFromEntityInWorldCoords(object, -moveWeight, 0.0, 0.0)
			SetEntityCoords(object,pos.x,pos.y,pos.z)
		else
			pos = GetOffsetFromEntityInWorldCoords(object,0.0, 0.0, 0.0)
			SetEntityCoords(object,pos.x-moveWeight,pos.y,pos.z)
		end
	elseif direction == "l" then
		if secondaryMode == "Local" then
			pos = GetOffsetFromEntityInWorldCoords(object, 0.0, moveWeight, 0.0)
			SetEntityCoords(object,pos.x,pos.y,pos.z)
		else
			pos = GetOffsetFromEntityInWorldCoords(object,0.0, 0.0, 0.0)
			SetEntityCoords(object,pos.x,pos.y+moveWeight,pos.z)
		end
	elseif direction == "r" then
		if secondaryMode == "Local" then
			pos = GetOffsetFromEntityInWorldCoords(object, 0.0, -moveWeight, 0.0)
			SetEntityCoords(object,pos.x,pos.y,pos.z)
		else
			pos = GetOffsetFromEntityInWorldCoords(object,0.0, 0.0, 0.0)
			SetEntityCoords(object,pos.x,pos.y-moveWeight,pos.z)
		end
	elseif direction == "u" then
		if secondaryMode == "Local" then
			pos = GetOffsetFromEntityInWorldCoords(object, 0.0, 0.0, moveWeight)
			SetEntityCoords(object,pos.x,pos.y,pos.z)
		else
			pos = GetOffsetFromEntityInWorldCoords(object,0.0, 0.0, 0.0)
			SetEntityCoords(object,pos.x,pos.y,pos.z+moveWeight)
		end
	elseif direction == "d" then
		if secondaryMode == "Local" then
			pos = GetOffsetFromEntityInWorldCoords(object, 0.0, 0.0,-moveWeight)
			SetEntityCoords(object,pos.x,pos.y,pos.z)
		else
			pos = GetOffsetFromEntityInWorldCoords(object,0.0, 0.0, 0.0)
			SetEntityCoords(object,pos.x,pos.y,pos.z-moveWeight)
		end
	end
	--SetEntityCoords(object,pos.x,pos.y,pos.z)
end

function Select()

end



function stopFuniture()
	CurrentPlacedObjects = {}
	cost = 0
	for i,v in ipairs(loadedObjects) do
		DeleteEntity(v)
	end


	DeleteEntity(object)
	objectIndex = 1
	currentObject = ""
	object = nil
	isInCamera = false
end

function nextObject()
	if objectIndex < #props then
		objectIndex = objectIndex + 1
		currentObject = props[objectIndex][1]
	else
		objectIndex = 1
		currentObject = props[objectIndex][1]
	end
	createObject()
end

function backObject()
	if objectIndex ~= 1 then
		objectIndex = objectIndex - 1
		currentObject = props[objectIndex][1]
	else
		objectIndex = #props
		currentObject = props[objectIndex][1]
	end
	createObject()
end

function centerObject()
	AttachEntityToEntity(object, PlayerPedId(), 11816, 0.0, 2.0, -0.5, 0.0, 0.0, 180.0, true, true, true, true, 1, true)
	DetachEntity(object, 1, true)
	DetachEntity(PlayerPedId(), 1, true)
	FreezeEntityPosition(object, true)
	pos = GetOffsetFromEntityInWorldCoords(object, 0.0, 0.0, 0.0)
	rotation = GetEntityRotation(object,2)
end

function createObject()

	if object == nil then
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.2, 0.0))
		local heading = GetEntityHeading(PlayerPedId())
		RequestModel(GetHashKey(currentObject))
		while not HasModelLoaded(GetHashKey(currentObject)) do
			Citizen.Wait(1)
		end

		object = CreateObject(GetHashKey(currentObject), x, y, z, false, true, true)
		SetEntityHeading(object, heading)
		FreezeEntityPosition(object, true)
		centerObject()
		SetEntityCollision(object,false,false)
		SetEntityAlpha(object, 195, false)
		SetModelAsNoLongerNeeded(GetHashKey(currentObject))
	else

		DeleteEntity(object)

		RequestModel(GetHashKey(currentObject))
		while not HasModelLoaded(GetHashKey(currentObject)) do
			Citizen.Wait(1)
		end

		object = CreateObject(GetHashKey(currentObject),pos.x, pos.y, pos.z, false, true, true)
		SetEntityHeading(object, currentHeading)
		FreezeEntityPosition(object, true)
		SetEntityCollision(object,false,false)
		SetEntityAlpha(object, 195, false)
		
		SetModelAsNoLongerNeeded(GetHashKey(currentObject))

	end

end

function renderText()

	if showInfo then

		DrawRect(0.050, 0.574,0.09,0.380,0,0,0,150)

		DrawRect(0.050, 0.360,0.092,0.030,0,0,0,70)

		SetTextFont(6)
		SetTextProportional(0)
		SetTextScale(0.43, 0.43)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(0)
		SetTextEntry("STRING")
		AddTextComponentString("Build Info")
		DrawText(0.030, 0.346)

		SetTextFont(4)
		SetTextProportional(0)
		SetTextScale(0.33, 0.33)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(0)
		SetTextEntry("STRING")
		AddTextComponentString("- Build Mode: "..buildMode.." ("..secondaryMode..")")
		DrawText(0.010, 0.390)

		SetTextFont(4)
		SetTextProportional(0)
		SetTextScale(0.35, 0.35)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(0)
		SetTextEntry("STRING")
		AddTextComponentString("- Move Weight: "..moveWeight)
		DrawText(0.010, 0.420)

		SetTextFont(4)
		SetTextProportional(0)
		SetTextScale(0.35, 0.35)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(0)
		SetTextEntry("STRING")
		AddTextComponentString("- Object Cost: "..props[objectIndex][2])
		DrawText(0.010, 0.450)

		SetTextFont(4)
		SetTextProportional(0)
		SetTextScale(0.35, 0.35)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(0)
		SetTextEntry("STRING")
		AddTextComponentString("------------------------------------")
		DrawText(0.010, 0.480)

		SetTextFont(4)
		SetTextProportional(0)
		SetTextScale(0.35, 0.35)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(0)
		SetTextEntry("STRING")
		AddTextComponentString("- Objects : "..currentAmount.."/"..maxObjects)
		DrawText(0.010, 0.510)

		SetTextFont(4)
		SetTextProportional(0)
		SetTextScale(0.35, 0.35)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(0)
		SetTextEntry("STRING")
		AddTextComponentString("- Total Cost : "..cost)
		DrawText(0.010, 0.540)

		SetTextFont(4)
		SetTextProportional(0)
		SetTextScale(0.35, 0.35)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(0)
		SetTextEntry("STRING")
		AddTextComponentString("------------------------------------")
		DrawText(0.010, 0.580)

		SetTextFont(4)
		SetTextProportional(0)
		SetTextScale(0.35, 0.35)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(0)
		SetTextEntry("STRING")
		AddTextComponentString("- Current Object -")
		DrawText(0.023, 0.610)

		SetTextFont(4)
		SetTextProportional(0)
		SetTextScale(0.35, 0.35)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(0)
		SetTextEntry("STRING")
		AddTextComponentString(currentObject)
		DrawText(0.020, 0.640)
		
	end

	if showControls then
		if buildMode == "Movement" or buildMode == "Roate" then
			DrawRect(0.050, 0.874,0.09,0.180,0,0,0,150)
			DrawRect(0.15, 0.874,0.09,0.180,0,0,0,150)

			SetTextFont(4)
			SetTextProportional(0)
			SetTextScale(0.35, 0.35)
			SetTextColour(255, 255, 255, 255)
			SetTextCentre(0)
			SetTextEntry("STRING")
			AddTextComponentString(" - [M] Object Back")
			DrawText(0.010, 0.804)

			SetTextFont(4)
			SetTextProportional(0)
			SetTextScale(0.35, 0.35)
			SetTextColour(255, 255, 255, 255)
			SetTextCentre(0)
			SetTextEntry("STRING")
			AddTextComponentString(" - [ , ] Object Next")
			DrawText(0.010, 0.834)

			SetTextFont(4)
			SetTextProportional(0)
			SetTextScale(0.35, 0.35)
			SetTextColour(255, 255, 255, 255)
			SetTextCentre(0)
			SetTextEntry("STRING")
			AddTextComponentString(" - [B] Object Center")
			DrawText(0.010, 0.864)

			SetTextFont(4)
			SetTextProportional(0)
			SetTextScale(0.35, 0.35)
			SetTextColour(255, 255, 255, 255)
			SetTextCentre(0)
			SetTextEntry("STRING")
			AddTextComponentString(" - Ctrl + [  ] Change Weight")
			DrawText(0.010, 0.894)

			SetTextFont(4)
			SetTextProportional(0)
			SetTextScale(0.35, 0.35)
			SetTextColour(255, 255, 255, 255)
			SetTextCentre(0)
			SetTextEntry("STRING")
			AddTextComponentString(" - [Ctrl+Home] Secondary")
			DrawText(0.010, 0.924)

			if buildMode == "Roate" then

				SetTextFont(4)
				SetTextProportional(0)
				SetTextScale(0.35, 0.35)
				SetTextColour(255, 255, 255, 255)
				SetTextCentre(0)
				SetTextEntry("STRING")
				AddTextComponentString(" - [Num 4/6] yaw ")
				DrawText(0.110, 0.804)

				SetTextFont(4)
				SetTextProportional(0)
				SetTextScale(0.35, 0.35)
				SetTextColour(255, 255, 255, 255)
				SetTextCentre(0)
				SetTextEntry("STRING")
				AddTextComponentString(" - [Num 8/5] pitch")
				DrawText(0.110, 0.834)

				SetTextFont(4)
				SetTextProportional(0)
				SetTextScale(0.35, 0.35)
				SetTextColour(255, 255, 255, 255)
				SetTextCentre(0)
				SetTextEntry("STRING")
				AddTextComponentString(" - [Num 7/9] roll")
				DrawText(0.110, 0.864)

			else

				SetTextFont(4)
				SetTextProportional(0)
				SetTextScale(0.35, 0.35)
				SetTextColour(255, 255, 255, 255)
				SetTextCentre(0)
				SetTextEntry("STRING")
				AddTextComponentString(" - [Num 4/6] Left/Right")
				DrawText(0.110, 0.804)

				SetTextFont(4)
				SetTextProportional(0)
				SetTextScale(0.35, 0.35)
				SetTextColour(255, 255, 255, 255)
				SetTextCentre(0)
				SetTextEntry("STRING")
				AddTextComponentString(" - [Num 8/5] Foward/Back")
				DrawText(0.110, 0.834)

				SetTextFont(4)
				SetTextProportional(0)
				SetTextScale(0.35, 0.35)
				SetTextColour(255, 255, 255, 255)
				SetTextCentre(0)
				SetTextEntry("STRING")
				AddTextComponentString(" - [Num 7/9] Up/Down")
				DrawText(0.110, 0.864)

				SetTextFont(4)
				SetTextProportional(0)
				SetTextScale(0.35, 0.35)
				SetTextColour(255, 255, 255, 255)
				SetTextCentre(0)
				SetTextEntry("STRING")
				AddTextComponentString(" - [Right Click] Drag")
				DrawText(0.110, 0.894)

				SetTextFont(4)
				SetTextProportional(0)
				SetTextScale(0.35, 0.35)
				SetTextColour(255, 255, 255, 255)
				SetTextCentre(0)
				SetTextEntry("STRING")
				AddTextComponentString(" - [Scroll] Distance")
				DrawText(0.110, 0.924)

			end
		end

	end

end



function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end


function setupScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    Button(GetControlInstructionalButton(2, 213, true))
    ButtonMessage("Change Mode")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    Button(GetControlInstructionalButton(2, 10, true))
    ButtonMessage("Toggle Info")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    Button(GetControlInstructionalButton(2, 11, true))
    ButtonMessage("Toggle Controls")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    Button(GetControlInstructionalButton(2, 74, true))
    ButtonMessage("Exit")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(100)
    PopScaleformMovieFunctionVoid()

    return scaleform
end



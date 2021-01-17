CanDropOff = true
DropOffTime = 0

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function drawTxt(x, y, width, height, scale, text, r, g, b, a)
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

RegisterNetEvent("np-dirtymoney:allowDirtyMoneyDrops")
AddEventHandler("np-dirtymoney:allowDirtyMoneyDrops", function()
	if DropOffTime == 0 then
		DropOffTime = 300
		CanDropOff = false
		while DropOffTime > 0 do
			Citizen.Wait(1000)
			DropOffTime = DropOffTime - 1
		end
		CanDropOff = true
		DropOffTime = 0
		--TriggerEvent("DoLongHudText","Marked Bills is ready to be dropped off!")
	else
		DropOffTime = 300
	end
end)

RegisterNetEvent("np-dirtymoney:attemptDirtyMoneyDrops")
AddEventHandler("np-dirtymoney:attemptDirtyMoneyDrops", function()
	if DropOffTime == 0 then
		TriggerEvent('np-dirtymoney:allowDirtyMoneyDrops')
		--TriggerServerEvent('mobdelivery:checkjob')
		--TriggerServerEvent("np-dirtymoney:alterDirtyMoney", "TurnToCash", 0)
	else
		local msgtoplayer = "You must wait " .. DropOffTime .. " Seconds to drop off your cash.."
		TriggerEvent("DoLongHudText", msgtoplayer)
	end

end)

function IsNearDirtyMoney()
	if #(vector3(925.329, 46.152,80.908) - GetEntityCoords(PlayerPedId())) < 15 then
		return true
	end	
end



--x=925.329, y=46.152, z=80.908


backpack = false
attachedProp = 0

RegisterNetEvent("dmbackpack")
AddEventHandler("dmbackpack", function(amt)

	if amt > 5000 and not backpack then
		backpack = true
		attachProp("prop_cs_heist_bag_01", 24816, 0.15, -0.4, -0.38, 90.0, 0.0, 0.0)
	elseif backpack and amt < 5000 then
		backpack = false
		removeAttachedProp()
	end
end)

function removeAttachedProp()
	DeleteEntity(attachedProp)
	attachedProp = 0
end

function attachProp(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp()
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	SetCurrentPedWeapon(PlayerPedId(), 0xA2719263) 
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end
	attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	exports["isPed"]:GlobalObject(attachedProp)
	AttachEntityToEntity(attachedProp, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

--attachProp("prop_cs_heist_bag_01", 24816, 0.15, -0.4, -0.38, 90.0, 0.0, 0.0)


RegisterNetEvent("dirtymoney:dropDirty")
AddEventHandler("dirtymoney:dropDirty", function(DirtyMoney,amount)
if DirtyMoney >= amount then
	local pos = GetEntityCoords(PlayerPedId())
		TriggerEvent("DoLongHudText","You Dropped $ "..amount.." Marked Bills.")
		TriggerServerEvent("np-dirtymoney:alterDirtyMoney","ItemDrop",amount)
		TriggerEvent('item:itemDrop',{"DirtyMoney"},{amount},{pos.x,pos.y,pos.z-0.7},{false},false)
	else
		TriggerEvent("DoLongHudText","You do not have enought Marked Bills to drop.")
	end	
end)

RegisterNetEvent("dirtymoney:dropCash")
AddEventHandler("dirtymoney:dropCash", function(amount)
	local pos = GetEntityCoords(PlayerPedId())
	TriggerEvent("DoLongHudText","You Dropped $ "..amount..".")
	TriggerEvent('item:itemDrop',{"Money"},{amount},{pos.x,pos.y,pos.z-0.7},{false},false)

end)
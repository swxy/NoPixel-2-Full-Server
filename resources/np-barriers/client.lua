RegisterNetEvent('barriers:pickup')
RegisterNetEvent('barriers:cone')
RegisterNetEvent('barriers:sbarrier')
RegisterNetEvent('barriers:barrier')

objList = {
	[1] = "prop_mp_cone_01",
	[2] = "prop_mp_barrier_02b",
	[3] = "prop_barrier_work05",
	[4] = "prop_flare_01",
	[5] = "prop_flare_01b",
	[6] = "prop_mp_cone_01",
}

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

AddEventHandler('barriers:pickup', function()
    loadAnimDict('anim@narcotics@trash')
    TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1700, 49, 1.0, 0, 0, 0)
	local finished = exports["np-taskbar"]:taskBar(1800,"Picking up barrier")
  	if finished == 100 then
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.25, 0.0))
		local heading = GetEntityHeading(PlayerPedId())
		local objFound = 0
		for i = 1, #objList do
			local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.25, 0.0))
			objFound = GetClosestObjectOfType(x, y, z, 5.0, GetHashKey(objList[i]), 0, 0, 0)
			DeleteObject(objFound)
			DeleteEntity(objFound)

			DeleteObject(objFound)
			DeleteEntity(objFound)
		end
		TriggerServerEvent("aidsarea",false,x,y,z, heading)
	end
end)

AddEventHandler('barriers:cone', function()
    loadAnimDict('anim@narcotics@trash')
    TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1700, 49, 3.0, 0, 0, 0)
	local finished = exports["np-taskbar"]:taskBar(1800,"Placing Cone")
  	if finished == 100 then	
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.2, 0.0))
		local heading = GetEntityHeading(PlayerPedId())
		RequestModel('prop_mp_cone_01')
		while not HasModelLoaded('prop_mp_cone_01') do
			Citizen.Wait(1)
		end
		local cone = CreateObject('prop_mp_cone_01', x, y, z, true, false, false)
		exports["isPed"]:GlobalObject(cone)
		PlaceObjectOnGroundProperly(cone)
		SetEntityHeading(cone, heading)
	end
end)

AddEventHandler('barriers:sbarrier', function()
    loadAnimDict('anim@narcotics@trash')
    TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1700, 49, 3.0, 0, 0, 0)
	local finished = exports["np-taskbar"]:taskBar(1800,"Placing Barrier")
  	if finished == 100 then	
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.2, 0.0))
		local heading = GetEntityHeading(PlayerPedId())
		RequestModel('prop_barrier_work05')
		while not HasModelLoaded('prop_barrier_work05') do
			Citizen.Wait(1)
		end
		local sbarrier = CreateObject('prop_barrier_work05', x, y, z, true, false, false)
		exports["isPed"]:GlobalObject(sbarrier)
		PlaceObjectOnGroundProperly(sbarrier)
		SetEntityHeading(sbarrier, heading)
	end
end)

AddEventHandler('barriers:barrier', function()
    loadAnimDict('anim@narcotics@trash')
    TaskPlayAnim(PlayerPedId(),'anim@narcotics@trash', 'drop_front',0.9, -8, 1700, 49, 3.0, 0, 0, 0)
	local finished = exports["np-taskbar"]:taskBar(1800,"Placing Roadblock")
  	if finished == 100 then
		local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.2, 0.0))
		local c1x,c1y,c1z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 1.5, 2.2, 0.0))
		local c2x,c2y,c2z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), -1.5, 2.2, 0.0))
		local heading = GetEntityHeading(PlayerPedId())
		RequestModel('prop_barrier_work05')
		while not HasModelLoaded('prop_barrier_work05') do
			Citizen.Wait(1)
		end
		local barrier = CreateObject('prop_barrier_work05', x, y, z, true, false, false)
		local cone = CreateObject('prop_mp_cone_01', c1x,c1y,c1z, true, false, false)
		local cone2 = CreateObject('prop_mp_cone_01', c2x,c2y,c2z, true, false, false)
		PlaceObjectOnGroundProperly(barrier)
		PlaceObjectOnGroundProperly(cone)
		PlaceObjectOnGroundProperly(cone2)
		SetEntityHeading(barrier, heading)
		exports["isPed"]:GlobalObject(barrier)
		exports["isPed"]:GlobalObject(cone)
		exports["isPed"]:GlobalObject(cone2)
		TriggerEvent("DoLongHudText","Traffic Blocked in facing direction.",1)
		TriggerServerEvent("aidsarea",true,x,y,z, heading)
	end
end)


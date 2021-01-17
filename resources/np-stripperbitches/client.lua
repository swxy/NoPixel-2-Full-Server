
function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function stripdance1()

	ClearPedSecondaryTask(PlayerPedId())

	loadAnimDict( "mini@strip_club@lap_dance@ld_girl_a_song_a_p1" )
	loadAnimDict( "mini@strip_club@lap_dance@ld_girl_a_song_a_p2" )
	loadAnimDict( "mini@strip_club@lap_dance@ld_girl_a_exit" )
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", "ld_girl_a_song_a_p1_f", 1.0, -1.0, -1, 0, 1, 0, 0, 0) 
	length = GetAnimDuration("mini@strip_club@lap_dance@ld_girl_a_song_a_p1", "ld_girl_a_song_a_p1_f")
	Citizen.Wait(length)      	
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@lap_dance@ld_girl_a_song_a_p2", "ld_girl_a_song_a_p2_f", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@lap_dance@ld_girl_a_song_a_p2", "ld_girl_a_song_a_p2_f")
	Citizen.Wait(length) 
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@lap_dance@ld_girl_a_exit", "ld_girl_a_exit_f", 1.0, -1.0, -1, 0, 1, 0, 0, 0)

end

function stripdance2()

	ClearPedSecondaryTask(PlayerPedId())

	loadAnimDict( "mini@strip_club@lap_dance_2g@ld_2g_p1" )
	loadAnimDict( "mini@strip_club@lap_dance_2g@ld_2g_p2" )
	loadAnimDict( "mini@strip_club@lap_dance@ld_girl_a_exit" )
       	
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@lap_dance_2g@ld_2g_p1", "ld_2g_p1_s1", 1.0, -1.0, -1, 0, 1, 0, 0, 0) 
	length = GetAnimDuration("mini@strip_club@lap_dance_2g@ld_2g_p1", "ld_2g_p1_s1")
	Citizen.Wait(length)        	
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@lap_dance_2g@ld_2g_p2", "ld_2g_p2_s1", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@lap_dance_2g@ld_2g_p2", "ld_2g_p2_s1")
	Citizen.Wait(length)  
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@lap_dance@ld_girl_a_exit", "ld_girl_a_exit_f", 1.0, -1.0, -1, 0, 1, 0, 0, 0)

end
function poledance()

	ClearPedSecondaryTask(PlayerPedId())

	loadAnimDict( "mini@strip_club@pole_dance@pole_dance1" )
	loadAnimDict( "mini@strip_club@pole_dance@pole_dance2" )
	loadAnimDict( "mini@strip_club@pole_dance@pole_dance3" )
    loadAnimDict( "mini@strip_club@pole_dance@pole_enter" ) 	  	

	TaskPlayAnim( PlayerPedId(), "mini@strip_club@pole_dance@pole_enter", "pd_enter", 1.0, -1.0, -1, 0, 1, 0, 0, 0) 
	length = GetAnimDuration("mini@strip_club@pole_dance@pole_enter", "pd_enter")
	Citizen.Wait(length) 

	TaskPlayAnim( PlayerPedId(), "mini@strip_club@pole_dance@pole_dance1", "pd_dance_01", 1.0, -1.0, -1, 0, 1, 0, 0, 0) 
	length = GetAnimDuration("mini@strip_club@pole_dance@pole_dance1", "pd_dance_01")
	Citizen.Wait(length)    
    	
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@pole_dance@pole_dance2", "pd_dance_02", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@pole_dance@pole_dance2", "pd_dance_02")
	Citizen.Wait(length)  

	TaskPlayAnim( PlayerPedId(), "mini@strip_club@pole_dance@pole_dance3", "pd_dance_03", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@pole_dance@pole_dance3", "pd_dance_03")
	Citizen.Wait(length)  

end

Dancing = false
RegisterNetEvent("attachtopole")
AddEventHandler("attachtopole", function()
		local ped = PlayerPedId()
		local chair = CreateObject( `prop_chair_01a`, 112.59926422119,-1286.5965087891,28.45867729187, true, false, false)
		SetEntityHeading(chair,GetEntityHeading(ped)+180.0)
		SetEntityCollision(chair,false,false)
		--SetEntityVisible(chair, false)
		SetEntityCoords(chair, 112.59926422119,-1286.5965087891,28.45867729187)
		Dancing = true

		AttachEntityToEntity(ped, chair, 20, 0.0, 0.0, 1.0, 180.0, 180.0, 0.0, false, false, false, false, 1, true)
		DeleteObject(chair)
end)



function privdance()

	ClearPedSecondaryTask(PlayerPedId())
	SetEntityCollision(PlayerPedId(),false,false)

	loadAnimDict( "mini@strip_club@private_dance@part1" )
	loadAnimDict( "mini@strip_club@private_dance@part2" )
	loadAnimDict( "mini@strip_club@private_dance@part3" )
  	
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@private_dance@part1", "priv_dance_p1", 1.0, -1.0, -1, 0, 1, 0, 0, 0) 
	length = GetAnimDuration("mini@strip_club@private_dance@part1", "priv_dance_p1")
	Citizen.Wait(length)        	
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@private_dance@part2", "priv_dance_p2", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@private_dance@part2", "priv_dance_p2")
	Citizen.Wait(length)  
	TaskPlayAnim( PlayerPedId(), "mini@strip_club@private_dance@part3", "priv_dance_p3", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
	length = GetAnimDuration("mini@strip_club@private_dance@part3", "priv_dance_p3")
	Citizen.Wait(length)  
	SetEntityCollision(PlayerPedId(),true,true)

end


RegisterNetEvent("stripper:dance")
AddEventHandler("stripper:dance", function()
	stripdance1()
end)
RegisterNetEvent("stripper:dance2")
AddEventHandler("stripper:dance2", function()
	stripdance2()
end)

RegisterNetEvent("stripper:dance3")
AddEventHandler("stripper:dance3", function()
	poledance()
end)
RegisterNetEvent("stripper:dance4")
AddEventHandler("stripper:dance4", function()
	privdance()
end)

RegisterNetEvent("safecracking:start")
AddEventHandler("safecracking:start", function()
	TriggerEvent("notification", "Cracking safe!",1)
	TriggerEvent("safecracking:loop",10,"safe:success")
end)

cracking = false
RegisterNetEvent("safecracking:loop")
AddEventHandler("safecracking:loop", function(difficulty,functionName)
	loadSafeTexture()
	loadSafeAudio()
	difficultySetting = {}
	for z = 1, difficulty do
		difficultySetting[z] = 1
	end
	curLock = 1
	factor = difficulty
	i = 0.0
	safelock = 0
	desirednum = math.floor(math.random(99))
	if desirednum == 0 then desirednum = 1 end
	openString = "lock_open"
	closedString = "lock_closed"
	cracking = true
	mybasepos = GetEntityCoords(PlayerPedId())
	dicks = 1
	local pinfall = false

	TriggerEvent("notification","Press Shift+F or F to rotate, H to crack!")

	while cracking do

		 
		DisableControlAction(38, 0, true)
		DisableControlAction(44, 0, true)
		DisableControlAction(74, 0, true)

		if IsControlPressed(1, 21) and IsControlPressed(1, 23) then
			if dicks > 1 then
				i = i + 1.8
				PlaySoundFrontend( 0, "TUMBLER_TURN", "SAFE_CRACK_SOUNDSET", true );

				dicks = 0
				crackingsafeanim(1)
			end
		end

		if IsControlPressed(1, 23) then

			if dicks > 1 then
				i = i - 1.8
				PlaySoundFrontend( 0, "TUMBLER_TURN", "SAFE_CRACK_SOUNDSET", true );
				dicks = 0
				crackingsafeanim(1)
			end
		end

		dicks = dicks + 0.2
		Citizen.Wait(1)

		if i < 0.0 then i = 360.0 end
		if i > 360.0 then i = 0.0 end

		safelock = math.floor(100-(i / 3.6))

		if #(mybasepos - GetEntityCoords(PlayerPedId())) > 1 or curLock > difficulty then
			cracking = false
		end

		if IsDisabledControlPressed(1, 74) and safelock ~= desirednum then
			Citizen.Wait(1000)
		end

		if safelock == desirednum then

			if not pinfall then
				PlaySoundFrontend( 0, "TUMBLER_PIN_FALL", "SAFE_CRACK_SOUNDSET", true );
				pinfall = true
			end

			if IsDisabledControlPressed(1, 74) then
				pinfall = false
				PlaySoundFrontend( 0, "TUMBLER_RESET", "SAFE_CRACK_SOUNDSET", true );
				factor = factor / 2
				i = 0.0
				safelock = 0
				desirednum = math.floor(math.random(99))
				crackingsafeanim(3)
				if desirednum == 0 then desirednum = 1 end
				difficultySetting[curLock] = 0
				curLock = curLock + 1
			end

		else
			pinfall = false
		end

		DrawSprite( "MPSafeCracking", "Dial_BG", 0.65, 0.5, 0.18, 0.32, 0, 255, 255, 211, 255 )
		DrawSprite( "MPSafeCracking", "Dial", 0.65, 0.5, 0.09, 0.16, i, 255, 255, 211, 255 )



		addition = 0.45
		xaddition = 0.58
		for x = 1, difficulty do

			if difficultySetting[x] ~= 1 then
				DrawSprite( "MPSafeCracking", openString, xaddition, addition, 0.012, 0.024, 0, 255, 255, 211, 255 )
			else
				DrawSprite( "MPSafeCracking", closedString, xaddition, addition, 0.012, 0.024, 0, 255, 255, 211, 255 )
			end

			addition = addition + 0.05

			if x == 10 or x == 20 or x == 30 then
				addition = 0.25
				xaddition = xaddition + 0.05
			end

		end

		--factor = factor / factor
		-- if factor < 1 then factor = 0.5 end

	end

	if curLock > difficulty then
		TriggerEvent(functionName)
	end
	TriggerEvent("robbery:register:finishedLockpick")
	resetAnim()

end)

animsIdle = {}
animsIdle[1] = "idle_base"
animsIdle[2] = "idle_heavy_breathe"
animsIdle[3] = "idle_look_around"

animsSucceed = {}
animsSucceed[1] = "dial_turn_succeed_1"
animsSucceed[2] = "dial_turn_succeed_2"
animsSucceed[3] = "dial_turn_succeed_3"
animsSucceed[4] = "dial_turn_succeed_4"


function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function resetAnim()
	 local player = GetPlayerPed( -1 )
	ClearPedSecondaryTask(player)
end

function crackingsafeanim(animType)
    local player = GetPlayerPed( -1 )
  	if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 
        loadAnimDict( "mini@safe_cracking" )


        if animType == 1 then

			if IsEntityPlayingAnim(player, "mini@safe_cracking", "dial_turn_anti_fast_1", 3) then
				--ClearPedSecondaryTask(player)
			else
				TaskPlayAnim(player, "mini@safe_cracking", "dial_turn_anti_fast_1", 8.0, -8, -1, 49, 0, 0, 0, 0)
			end	

	    end

        if animType == 2 then
	        TaskPlayAnim( player, "mini@safe_cracking", animsIdle[math.floor(math.ceil(4))], 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
	    end

        if animType == 3 then
	        TaskPlayAnim( player, "mini@safe_cracking", animsSucceed[math.floor(math.ceil(4))], 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
	    end	

    end
end




function loadSafeTexture()
	RequestStreamedTextureDict( "MPSafeCracking", false );
	while not HasStreamedTextureDictLoaded( "MPSafeCracking" ) do
		Citizen.Wait(0)
	end
end

function loadSafeAudio()
	RequestAmbientAudioBank( "SAFE_CRACK", false )
end

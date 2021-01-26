local focusTaken = false
--[[------------------------------------------------------------------------

    Wraith Radar System - v1.02
    Created by WolfKnight

------------------------------------------------------------------------]]--

--[[------------------------------------------------------------------------
    Resource Rename Fix 
------------------------------------------------------------------------]]--
Citizen.CreateThread( function()
    Citizen.Wait( 1000 )
    local resourceName = GetCurrentResourceName()
    SendNUIMessage( { resourcename = resourceName } )
end )

--[[------------------------------------------------------------------------
    Utils 
------------------------------------------------------------------------]]--
function round( num )
    return tonumber( string.format( "%.0f", num ) )
end

function oppang( ang )
    return ( ang + 180 ) % 360 
end 

function FormatSpeed( speed )
    return string.format( "%03d", speed )
end 

RegisterNetEvent("nowIsCop")
AddEventHandler("nowIsCop", function(cb)
    cb(isCop)
end)
RegisterNetEvent('police:noLongerCop')
AddEventHandler('police:noLongerCop', function()
    isCop = false
end)

AddEventHandler("np-voice:focus:set", function(pState)
  focusTaken = pState
end)

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
    if isMedic and job ~= "ems" then isMedic = false isInService = false end
    if isCop and job ~= "police" then isCop = false isInService = false end
    if isNews and job ~= "news" then isNews = false end
    if job == "police" then isCop = true isInService = true end
    if job == "ems" then isMedic = true isInService = true end
    if job == "news" then isNews = true end
end)

function GetVehicleInDirectionSphere( entFrom, coordFrom, coordTo )
    local rayHandle = StartShapeTestCapsule( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 2.0, 10, entFrom, 7 )
    local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
    return vehicle
end

function IsEntityInMyHeading( myAng, tarAng, range )
    local rangeStartFront = myAng - ( range / 2 )
    local rangeEndFront = myAng + ( range / 2 )

    local opp = oppang( myAng )

    local rangeStartBack = opp - ( range / 2 )
    local rangeEndBack = opp + ( range / 2 )

    if ( ( tarAng > rangeStartFront ) and ( tarAng < rangeEndFront ) ) then 
        return true 
    elseif ( ( tarAng > rangeStartBack ) and ( tarAng < rangeEndBack ) ) then 
        return false 
    else 
        return nil 
    end 
end 


--[[------------------------------------------------------------------------
    Police Vehicle Radar 
------------------------------------------------------------------------]]--
local lockplates = false
local radarEnabled = false 
local hidden = false 
local radarInfo = 
{ 
    patrolSpeed = "000", 
    speedType = "mph", 
    fwdPrevVeh = 0, 
    fwdXmit = true, 
    fwdMode = "same", 
    fwdSpeed = "000", 
    fwdFast = "000", 
    fwdFastLocked = false, 
    fwdDir = nil, 
    fwdFastSpeed = -1,
    bwdPrevVeh = 0, 
    bwdXmit = true, 
    bwdMode = "opp", 
    bwdSpeed = "OFF", 
    bwdFast = "OFF",
    bwdFastLocked = false, 
    bwdDir = nil, 
    bwdFastSpeed = -1, 

    fastResetLimit = 150,
    fastLimit = 80, 

    angles = { [ "same" ] = { x = 0.0, y = 35.0, z = 0.0 }, [ "opp" ] = { x = -10.0, y = 35.0, z = 0.0 } },

    lockBeep = true, 

    frontPlate = "No Lock",
    rearPlate = "No Lock"

}

RegisterNetEvent("platecheck:frontradar")
AddEventHandler("platecheck:frontradar", function()
    TriggerServerEvent('checkLicensePlate',radarInfo.frontPlate)
end)

RegisterNetEvent("platecheck:rearradar")
AddEventHandler("platecheck:rearradar", function()
    TriggerServerEvent('checkLicensePlate',radarInfo.rearPlate)
end)

local hotPlates = {}
local hotPlatesReason = {}
RegisterNetEvent("updateHotPlates")
AddEventHandler("updateHotPlates", function(newPlates,newReasons)
    hotPlates = newPlates
    hotPlatesReason = newReasons
end)

function isHotVehicle(plate)
    if hotPlates[string.upper(plate)] ~= nil or hotPlates[string.lower(plate)] ~= nil or hotPlates[plate] ~= nil then
        return true
    else
        return false
    end
end


RegisterNetEvent( 'startSpeedo' )
AddEventHandler( 'startSpeedo', function()
    local ped = GetPlayerPed( -1 )

    if ( IsPedSittingInAnyVehicle( ped ) ) then 
        local vehicle = GetVehiclePedIsIn( ped, false )

            radarEnabled = not radarEnabled

            if ( radarEnabled ) then 
                Notify( "Radar enabled.",5 )
            else 
                Notify( "Radar disabled.",5 )
            end 

            ResetFrontAntenna()
            ResetRearAntenna()

            SendNUIMessage({
                toggleradar = true, 
                fwdxmit = radarInfo.fwdXmit, 
                fwdmode = radarInfo.fwdMode, 
                bwdxmit = radarInfo.bwdXmit, 
                bwdmode = radarInfo.bwdMode
            })
    end
end)

RegisterNetEvent('wk:disableRadar')
AddEventHandler('wk:disableRadar', function()
    radarEnabled = false
    SendNUIMessage({
        disableRadar = true
    })
end)

RegisterNetEvent( 'wk:toggleRadar' )
AddEventHandler( 'wk:toggleRadar', function()
    local ped = GetPlayerPed( -1 )

    if ( IsPedSittingInAnyVehicle( ped ) ) then 
        local vehicle = GetVehiclePedIsIn( ped, false )

            radarEnabled = not radarEnabled

            if ( radarEnabled ) then 
                Notify( "Radar enabled.",5 )
            else 
                Notify( "Radar disabled.",5 )
            end 

            ResetFrontAntenna()
            ResetRearAntenna()

            SendNUIMessage({
                toggleradar = true, 
                fwdxmit = radarInfo.fwdXmit, 
                fwdmode = radarInfo.fwdMode, 
                bwdxmit = radarInfo.bwdXmit, 
                bwdmode = radarInfo.bwdMode
            })

    else 
        Notify( "Not in vehicle.",2 )
    end 
end )

RegisterNetEvent( 'wk:changeRadarLimit' )
AddEventHandler( 'wk:changeRadarLimit', function( speed ) 
    radarInfo.fastLimit = speed 
end )

function Radar_SetLimit()
    Citizen.CreateThread( function()
        DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 4 )

        while true do 
            if ( UpdateOnscreenKeyboard() == 1 ) then 
                local speedStr = GetOnscreenKeyboardResult()

                if ( string.len( speedStr ) > 0 ) then 
                    local speed = tonumber( speedStr )

                    if ( speed < 999 and speed > 1 ) then 
                        TriggerEvent( 'wk:changeRadarLimit', speed )
                    end 

                    break
                else 
                    DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 4 )
                end 
            elseif ( UpdateOnscreenKeyboard() == 2 ) then 
                break 
            end  

            Citizen.Wait( 0 )
        end 
    end )
end 

function ResetFrontAntenna()
    if ( radarInfo.fwdXmit ) then 
        radarInfo.fwdSpeed = "000"
        radarInfo.fwdFast = "000"  
    else 
        radarInfo.fwdSpeed = "OFF"
        radarInfo.fwdFast = "   "  
    end 

    radarInfo.fwdDir = nil
    radarInfo.fwdFastSpeed = -1 
    radarInfo.fwdFastLocked = false 
end 

function ResetRearAntenna()
    if ( radarInfo.bwdXmit ) then
        radarInfo.bwdSpeed = "000"
        radarInfo.bwdFast = "000"
    else 
        radarInfo.bwdSpeed = "OFF"
        radarInfo.bwdFast = "   "
    end 

    radarInfo.bwdDir = nil
    radarInfo.bwdFastSpeed = -1  
    radarInfo.bwdFastLocked = false
end 

function ResetFrontFast()
    if ( radarInfo.fwdXmit ) then 
        radarInfo.fwdFast = "000"
        radarInfo.fwdFastSpeed = -1 
        radarInfo.fwdFastLocked = false 

        SendNUIMessage( { lockfwdfast = false } )
    end 
end 

function ResetRearFast()
    if ( radarInfo.bwdXmit ) then 
        radarInfo.bwdFast = "000"
        radarInfo.bwdFastSpeed = -1 
        radarInfo.bwdFastLocked = false 

        SendNUIMessage( { lockbwdfast = false } )
    end 
end 

function CloseRadarRC()
    SendNUIMessage({
        toggleradarrc = true
    })

    TriggerEvent( 'wk:toggleMenuControlLock', false )

    SetNuiFocus( false )
end 

function ToggleSpeedType()
    radarInfo.speedType = "mph"
    Notify( "Speed type MPH.",5 )
end 

function ToggleLockBeep()
    if ( radarInfo.lockBeep ) then 
        radarInfo.lockBeep = false 
        Notify( "Radar beep disabled.",5 )
    else 
        radarInfo.lockBeep = true
        Notify( "Radar enabled.",5 )
    end    
end 

function GetVehSpeed( veh )
    if ( radarInfo.speedType == "mph" ) then 
        return GetEntitySpeed( veh ) * 2.236936
    else 
        return GetEntitySpeed( veh ) * 3.6
    end 
end 

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function ManageVehicleRadar()
    if ( radarEnabled ) then 
        local ped = GetPlayerPed( -1 )

        if ( IsPedSittingInAnyVehicle( ped ) ) then 
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped  ) then 
                -- Patrol speed 


              

                local vehicleSpeed = round( GetVehSpeed( vehicle ), 0 )

                radarInfo.patrolSpeed = FormatSpeed( vehicleSpeed )

                -- Rest of the radar options 
                local vehiclePos = GetEntityCoords( vehicle, true )
                local h = round( GetEntityHeading( vehicle ), 0 )

                -- Front Antenna 
                if ( radarInfo.fwdXmit ) then  
                    local forwardPosition = GetOffsetFromEntityInWorldCoords( vehicle, radarInfo.angles[ radarInfo.fwdMode ].x, radarInfo.angles[ radarInfo.fwdMode ].y, radarInfo.angles[ radarInfo.fwdMode ].z )
                    local fwdPos = { x = forwardPosition.x, y = forwardPosition.y, z = forwardPosition.z }
                    local _, fwdZ = GetGroundZFor_3dCoord( fwdPos.x, fwdPos.y, fwdPos.z + 500.0 )

                    if ( fwdPos.z < fwdZ and not ( fwdZ > vehiclePos.z + 1.0 ) ) then 
                        fwdPos.z = fwdZ + 0.5
                    end 

                    local packedFwdPos = vector3( fwdPos.x, fwdPos.y, fwdPos.z )
                    local fwdVeh = GetVehicleInDirectionSphere( vehicle, vehiclePos, packedFwdPos )

                    if ( DoesEntityExist( fwdVeh ) and IsEntityAVehicle( fwdVeh ) ) then 
                        local fwdVehSpeed = round( GetVehSpeed( fwdVeh ), 0 )

                        local fwdVehHeading = round( GetEntityHeading( fwdVeh ), 0 )
                        local dir = IsEntityInMyHeading( h, fwdVehHeading, 100 )

                        radarInfo.fwdSpeed = FormatSpeed( fwdVehSpeed )
                        radarInfo.fwdDir = dir 

                        if ( fwdVehSpeed > radarInfo.fastLimit and not radarInfo.fwdFastLocked ) and not lockplates then 
                            if ( radarInfo.lockBeep ) then 
                                PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                            end 

                            radarInfo.fwdFastSpeed = fwdVehSpeed 
                            radarInfo.fwdFastLocked = true 
                            radarInfo.frontPlate = GetVehicleNumberPlateText(fwdVeh) 
                            SendNUIMessage( { lockfwdfast = true } )
                        elseif fwdVehSpeed > radarInfo.fwdFastSpeed and not lockplates then
                            radarInfo.fwdFastSpeed = fwdVehSpeed
                            radarInfo.frontPlate = GetVehicleNumberPlateText(fwdVeh) 
                        end

                        radarInfo.fwdFast = FormatSpeed( radarInfo.fwdFastSpeed )

                        radarInfo.fwdPrevVeh = fwdVeh 
                    end
                end 

                -- Rear Antenna 
                if ( radarInfo.bwdXmit ) then 
                    local backwardPosition = GetOffsetFromEntityInWorldCoords( vehicle, radarInfo.angles[ radarInfo.bwdMode ].x, -radarInfo.angles[ radarInfo.bwdMode ].y, radarInfo.angles[ radarInfo.bwdMode ].z )
                    local bwdPos = { x = backwardPosition.x, y = backwardPosition.y, z = backwardPosition.z }
                    local _, bwdZ = GetGroundZFor_3dCoord( bwdPos.x, bwdPos.y, bwdPos.z + 500.0 )              

                    if ( bwdPos.z < bwdZ and not ( bwdZ > vehiclePos.z + 1.0 ) ) then 
                        bwdPos.z = bwdZ + 0.5
                    end

                    local packedBwdPos = vector3( bwdPos.x, bwdPos.y, bwdPos.z )                
                    local bwdVeh = GetVehicleInDirectionSphere( vehicle, vehiclePos, packedBwdPos )

                    if ( DoesEntityExist( bwdVeh ) and IsEntityAVehicle( bwdVeh ) ) then

                        local bwdVehSpeed = round( GetVehSpeed( bwdVeh ), 0 )

                        local bwdVehHeading = round( GetEntityHeading( bwdVeh ), 0 )
                        local dir = IsEntityInMyHeading( h, bwdVehHeading, 100 )

                        radarInfo.bwdSpeed = FormatSpeed( bwdVehSpeed )
                        radarInfo.bwdDir = dir 

                        if ( bwdVehSpeed > radarInfo.fastLimit and not radarInfo.bwdFastLocked ) and not lockplates then 
                            if ( radarInfo.lockBeep ) then 
                                PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
                            end 

                            radarInfo.bwdFastSpeed = bwdVehSpeed 
                            radarInfo.bwdFastLocked = true 

                            radarInfo.rearPlate = GetVehicleNumberPlateText(bwdVeh)

                            SendNUIMessage( { lockbwdfast = true } )
                        elseif bwdVehSpeed > radarInfo.bwdFastSpeed and not lockplates then
                            radarInfo.rearPlate = GetVehicleNumberPlateText(bwdVeh)
                            radarInfo.bwdFastSpeed = bwdVehSpeed 
                        end

                        radarInfo.bwdFast = FormatSpeed( radarInfo.bwdFastSpeed )

                        radarInfo.bwdPrevVeh = bwdVeh 
                    end  
                end  

                SendNUIMessage({
                    patrolspeed = radarInfo.patrolSpeed, 
                    fwdspeed = radarInfo.fwdSpeed, 
                    fwdfast = radarInfo.fwdFast, 
                    fwddir = radarInfo.fwdDir, 
                    bwdspeed = radarInfo.bwdSpeed, 
                    bwdfast = radarInfo.bwdFast, 
                    bwddir = radarInfo.bwdDir 
                })
            end 
        end 
    end 
end 


RegisterNetEvent( 'wk:radarRC' )
AddEventHandler( 'wk:radarRC', function()
    Citizen.Wait( 10 )

    TriggerEvent( 'wk:toggleMenuControlLock', true )

    SendNUIMessage({
        toggleradarrc = true
    })

    SetNuiFocus( true, true )
end )

RegisterNUICallback( "RadarRC", function( data, cb ) 
    -- Toggle Radar
    if ( data == "radar_toggle" ) then 
        TriggerEvent( 'wk:toggleRadar' )

    -- Front Antenna 
    elseif ( data == "radar_frontopp" and radarInfo.fwdXmit ) then
        radarInfo.fwdMode = "opp"
        SendNUIMessage( { fwdmode = radarInfo.fwdMode } )
    elseif ( data == "radar_frontxmit" ) then 
        radarInfo.fwdXmit = not radarInfo.fwdXmit 
        ResetFrontAntenna()
        SendNUIMessage( { fwdxmit = radarInfo.fwdXmit } )

        if ( radarInfo.fwdXmit == false ) then 
            radarInfo.fwdMode = "none" 
        else 
            radarInfo.fwdMode = "same" 
        end 

        SendNUIMessage( { fwdmode = radarInfo.fwdMode } )
    elseif ( data == "radar_frontsame" and radarInfo.fwdXmit ) then 
        radarInfo.fwdMode = "same"
        SendNUIMessage( { fwdmode = radarInfo.fwdMode } )

    -- Rear Antenna 
    elseif ( data == "radar_rearopp" and radarInfo.bwdXmit ) then
        radarInfo.bwdMode = "opp"
        SendNUIMessage( { bwdmode = radarInfo.bwdMode } )
    elseif ( data == "radar_rearxmit" ) then 
        radarInfo.bwdXmit = not radarInfo.bwdXmit 
        ResetRearAntenna()
        SendNUIMessage( { bwdxmit = radarInfo.bwdXmit } )

        if ( radarInfo.bwdXmit == false ) then 
            radarInfo.bwdMode = "none" 
        else 
            radarInfo.bwdMode = "same" 
        end 

        SendNUIMessage( { bwdmode = radarInfo.bwdMode } )
    elseif ( data == "radar_rearsame" and radarInfo.bwdXmit ) then 
        radarInfo.bwdMode = "same"
        SendNUIMessage( { bwdmode = radarInfo.bwdMode } )

    -- Set Fast Limit 
    elseif ( data == "radar_setlimit" ) then 
        CloseRadarRC()
        Radar_SetLimit()

    -- Speed Type 
    elseif ( data == "radar_speedtype" ) then 
        ToggleSpeedType()

    elseif ( data == "radar_lockbeep" ) then 
        ToggleLockBeep()

    -- Close 
    elseif ( data == "close" ) then 
        CloseRadarRC()
    end 

    if ( cb ) then cb( 'ok' ) end 
end )

Citizen.CreateThread( function()
    SetNuiFocus( false ) 

    while true do 
        ManageVehicleRadar()

        -- Only run 10 times a second, more realistic, also prevents spam 
        Citizen.Wait( 200 )
    end
end )

RegisterNetEvent( 'radar:alarm' )
AddEventHandler( 'radar:alarm', function()
    PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Citizen.Wait(100)
    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Citizen.Wait(100)
    PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Citizen.Wait(100)
    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Citizen.Wait(100)    
end)







Citizen.CreateThread( function()
    local oldStolenFP = 0
    local oldStolenRP = 0
    while true do 
        local ped = GetPlayerPed( -1 )

        -- These control pressed natives must be the disabled check ones. 
        local inVeh = IsPedSittingInAnyVehicle( ped )
        

        if inVeh then
            
            local veh = GetVehiclePedIsIn( ped, false )

            if radarEnabled and inVeh and GetPedInVehicleSeat( veh, -1 ) == ped then
                local fp = radarInfo.frontPlate
                local rp = radarInfo.rearPlate
                if isHotVehicle(fp) then
                    fp = string.gsub(fp, "0", "Ø")
                    if fp ~= oldStolenFP then
                        oldStolenFP = fp
                        TriggerEvent("radar:alarm")
                        SendNUIMessage( { frontchange = true, plate = fp .. " (F)" } )
                    else
                        SendNUIMessage( { frontchange = true, plate = fp .. " (F)" } )
                    end

                else
                    fp = string.gsub(fp, "0", "Ø")

                    if lockplates then
                        SendNUIMessage( { frontchange = true, plate = fp .. " (L)" } )
                    else
                        SendNUIMessage( { frontchange = true, plate = fp } )
                    end

                end

                if isHotVehicle(rp) then
                    rp = string.gsub(rp, "0", "Ø")
                    if rp ~= oldStolenRP then
                        oldStolenRP = rp
                        TriggerEvent("radar:alarm")
                        SendNUIMessage( { rearchange = true, plate = rp .. " (F)" } )
                    else
                        SendNUIMessage( { rearchange = true, plate = rp .. " (F)" } )
                    end
                    
                else
                    rp = string.gsub(rp, "0", "Ø")
                    if lockplates then
                        SendNUIMessage( { rearchange = true, plate = rp .. " (L)" } )
                    else
                        SendNUIMessage( { rearchange = true, plate = rp } )
                    end
                end    
            end
        end
        Citizen.Wait( 100 )
    end 
end )
















Citizen.CreateThread( function()
    local ped = GetPlayerPed( -1 )
            local veh = GetVehiclePedIsIn( ped, false )
    while true do 
        
        ped = GetPlayerPed( -1 )
        -- These control pressed natives must be the disabled check ones. 
        local inVeh = IsPedSittingInAnyVehicle( ped )
        
        if inVeh then
            veh = GetVehiclePedIsIn( ped, false )
        end

        if GetPedInVehicleSeat( veh, -1 ) == ped then
            

            -- LCtrl is pressed and M has just been pressed 

            if ( IsDisabledControlPressed( 1, 36 ) and IsDisabledControlJustPressed( 1, 243 ) and IsPedSittingInAnyVehicle( ped ) and isCop ) and not focusTaken then 

                lockplates = not lockplates
                if lockplates then
                    TriggerEvent("DoShortHudText","Radar Locked",5)
                else
                    TriggerEvent("DoShortHudText","Radar Unlocked",5)
                end
            end 

            -- LCtrl is not being pressed and M has just been pressed 
            if ( not IsDisabledControlPressed( 1, 36 ) and IsDisabledControlJustPressed( 1, 243 ) and IsPedSittingInAnyVehicle( ped ) and isCop ) and not focusTaken then 
                ResetFrontFast()
                ResetRearFast()
                TriggerEvent("DoShortHudText","Lockfast Reset",5)
            end 

            if ( IsDisabledControlJustPressed( 1, 244 ) and isCop and IsPedSittingInAnyVehicle( ped ) ) and not focusTaken then 
                TriggerEvent( 'wk:radarRC' )
            end 


            if ( radarEnabled and hidden ) then 

                hidden = false 
                SendNUIMessage( { hideradar = false } )
            end

        else


            if ( ( IsPauseMenuActive() and radarEnabled ) or ( not inVeh and radarEnabled) ) then 
                hidden = true 
                SendNUIMessage( { hideradar = true } )
            end 

            ped = GetPlayerPed( -1 )
            Citizen.Wait(1100)

        end
        Citizen.Wait( 1 )
    end 
end )


--[[------------------------------------------------------------------------
    Menu Control Lock - Prevents certain actions 
    Thanks to the authors of the ES Banking script. 
------------------------------------------------------------------------]]--
local locked = false 

RegisterNetEvent( 'wk:toggleMenuControlLock' )
AddEventHandler( 'wk:toggleMenuControlLock', function( lock ) 
    locked = lock 
end )

Citizen.CreateThread( function()
    while true do
        if ( locked ) then 
            Citizen.Wait( 0 )
            local ped = GetPlayerPed( -1 )  

            DisableControlAction( 0, 1, true ) -- LookLeftRight
            DisableControlAction( 0, 2, true ) -- LookUpDown
            DisableControlAction( 0, 24, true ) -- Attack
            DisablePlayerFiring( ped, true ) -- Disable weapon firing
            DisableControlAction( 0, 142, true ) -- MeleeAttackAlternate
            DisableControlAction( 0, 106, true ) -- VehicleMouseControlOverride

            SetPauseMenuActive( false )
        else
            Citizen.Wait( 100 )
        end

        
    end 
end )


--[[------------------------------------------------------------------------
    Notify  
------------------------------------------------------------------------]]--
function Notify( text,num )
    TriggerEvent("DoShortHudText",text,num)
end 
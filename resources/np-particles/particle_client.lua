local particleEffects = {}

local particleList = {
    ["vehExhaust"] = {["dic"] = "core",["name"] = "veh_exhaust_truck_rig",["loopAmount"] = 25,["timeCheck"] = 12000},
    ["lavaPour"] = {["dic"] = "core",["name"] = "ent_amb_foundry_molten_pour",["loopAmount"] = 1,["timeCheck"] = 12000},
    ["lavaSteam"] = {["dic"] = "core",["name"] = "ent_amb_steam_pipe_hvy",["loopAmount"] = 1,["timeCheck"] = 12000},
    ["spark"] = {["dic"] = "core",["name"] = "ent_amb_sparking_wires",["loopAmount"] = 1,["timeCheck"] = 12000},
    ["smoke"] = {["dic"] = "core",["name"] = "exp_grd_grenade_smoke",["loopAmount"] = 1,["timeCheck"] = 12000},
    ["test"] = {["dic"] = "core",["name"] = "ent_amb_steam_pipe_hvy",["loopAmount"] = 1,["timeCheck"] = 12000}
}

RegisterNetEvent("particle:StartClientParticle")
AddEventHandler("particle:StartClientParticle", function(x,y,z,particleId,allocatedID,rX,rY,rZ)
  if #(vector3(x,y,z) - GetEntityCoords(PlayerPedId())) < 100 then

    local particleDictionary = particleList[particleId].dic
    local particleName = particleList[particleId].name
    local loopAmount = particleList[particleId].loopAmount

   if not HasNamedPtfxAssetLoaded(particleDictionary) then
        RequestNamedPtfxAsset(particleDictionary)
        while not HasNamedPtfxAssetLoaded(particleDictionary) do
            Wait(1)
        end
    end

    for i=0,loopAmount do
        --UseParticleFxAssetNextCall(particleDictionary)
        SetPtfxAssetNextCall(particleDictionary)
       local particle =  StartParticleFxLoopedAtCoord(particleName, x, y, z, rX,rY,rZ, 1.0, false, false, false, false)

        local object = {["particle"] = particle,["id"] = allocatedID}
        particleEffects[#particleEffects+1]=object
        Citizen.Wait(0)
    end
  
  end
end)

RegisterNetEvent("particle:StopParticleClient")
AddEventHandler("particle:StopParticleClient", function(allocatedID)
   for j,particle in pairs(particleEffects) do
        if allocatedID == particle.id then
            RemoveParticleFx(particle.particle, true)
        end
    end
end)

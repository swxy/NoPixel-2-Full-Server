RegisterServerEvent('particle:StartParticleAtLocation')
AddEventHandler('particle:StartParticleAtLocation', function(x,y,z,particle,id,rx,ry,rz)
TriggerClientEvent('particle:StartClientParticle', -1, x,y,z,particle,id,rx,ry,rz)
end)

RegisterServerEvent('particle:StopParticle')
AddEventHandler('particle:StopParticle', function(x,y,z,particle,id,rx,ry,rz)
TriggerClientEvent('particle:StopParticleClient', -1, id)
end)
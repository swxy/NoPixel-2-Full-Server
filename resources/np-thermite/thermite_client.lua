local currentFires = {}

RegisterNetEvent("thermite:StartClientFires")
AddEventHandler("thermite:StartClientFires", function(x,y,z,arg1,arg2)
  if #(vector3(x,y,z) - GetEntityCoords(PlayerPedId())) < 100 then
    local fire = StartScriptFire(x,y,z,arg1,arg2)
    currentFires[#currentFires+1]=fire
  end
end)

RegisterNetEvent("thermite:StopFiresClient")
AddEventHandler("thermite:StopFiresClient", function()
   for p,j in ipairs(currentFires) do
        RemoveScriptFire(j)
    end
end)

function startFireAtLocation(x,y,z,time)
      local rand = math.random(7,11)

        for j=1,rand do   

            local randy = randomFloat(0,0.4,5)
            local randx = randomFloat(0,0.4,5)

            if math.random(1,2) == 2 then
                y = y + randy
            else
                y = y - randy
            end

            if math.random(1,2) == 2 then
                x = x + randx
            else
                x = x - randx
            end

            TriggerServerEvent("thermite:StartFireAtLocation",x,y,z,24,false)
      end

      Citizen.Wait(time)
      TriggerServerEvent("thermite:StopFires")

end

function randomFloat(min, max, precision)
    local range = max - min
    local offset = range * math.random()
    local unrounded = min + offset

    if not precision then
        return unrounded
    end

    local powerOfTen = 10 ^ precision
    return math.floor(unrounded * powerOfTen + 0.5) / powerOfTen
end

local currentlyInGame = false
local passed = false;


-----------------
-- dropAmount , the amount of letters to drop for completion
-- Letter , the letter set , letterset 1 = [q,w,e] letterset 2 = [q,w,e,j,k,l] , the set is used to determain what letters will drop
-- speed , the speed that the letters move on the screen
-- inter , interval , the time between letter drops
----------------

function startGame(dropAmount,letter,speed,inter)
  openGui()
  play(dropAmount,letter,speed,inter)
  currentlyInGame = true
  while currentlyInGame do
    Wait(400)
    if exports["isPed"]:isPed("dead") then 
      closeGui()
    end 
  end

  return passed;
end



local gui = false

function openGui()
    gui = true
    SetNuiFocus(true,true)
    SendNUIMessage({openPhone = true})
end

function play(dropAmount,letter,speed,inter) 
  SendNUIMessage({openSection = "playgame", amount = dropAmount,letterSet = letter,speed = speed,interval = inter})
end

function CloseGui()
    currentlyInGame = false
    gui = false
    SetNuiFocus(false,false)
    SendNUIMessage({openPhone = false})
end

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  CloseGui()
  cb('ok')
end)

RegisterNUICallback('failure', function(data, cb)
  passed = false
  CloseGui()
  cb('ok')
end)

RegisterNUICallback('complete', function(data, cb)
  passed = true
  CloseGui()
  cb('ok')
end)



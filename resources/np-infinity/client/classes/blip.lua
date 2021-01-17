EntityBlip = {}

function EntityBlip:new(pType, pNetId, pSettings)
    local this = {}

    this.id = pNetId
    this.mode = nil
    this.type = pType
    this.active = false
    this.handle = nil
    this.entity = GetLocalEntity(pType, pType)
    this.settings = pSettings

    self.__index = self

    return setmetatable(this, self)
end

function EntityBlip:setSettings()
    if not self.settings then return end

    if self.settings.color then
        SetBlipColour(self.handle, self.settings.color)
    end

    if self.settings.route then
        SetBlipColour(self.handle, self.settings.route)
    end

    if self.settings.short then
        SetBlipColour(self.handle, self.settings.short)
    end

    if self.settings.scale then
        SetBlipColour(self.handle, self.settings.scale)
    end

    if self.settings.heading then
        ShowHeadingIndicatorOnBlip(self.handle, self.settings.heading)
    end

    if self.settings.text then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(self.settings.text)
        EndTextCommandSetBlipName(self.handle)
    end
end

function EntityBlip:enable()
    if self.active then return end
    self.active = true

    Citizen.CreateThread(function ()
        while self.active do
            local entity = GetLocalEntity(self.type, self.id)

            if not DoesEntityExist(entity) then
                local coords = GetNetworkedCoords(self.type, self.id)

                if coords and self.mode == 'coords' then
                    SetBlipCoords(self.handle, coords.x, coords.y, coords.z)
                elseif coords then
                    RemoveBlip(self.handle)
                    self.handle = AddBlipForCoord(coords.x, coords.y, coords.z)
                    self.mode = 'coords'
                    self:setSettings()
                end
            elseif self.mode ~= 'entity' then
                RemoveBlip(self.handle)
                self.handle = AddBlipForEntity(entity)
                self.mode = 'entity'

                self:setSettings()
            end

            Citizen.Wait(500)
        end
    end)
end

function EntityBlip:disable()
    if not self.active then return end
    self.active = false
    RemoveBlip(self.handle)
end
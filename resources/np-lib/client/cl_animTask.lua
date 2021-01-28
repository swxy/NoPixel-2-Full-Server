AnimationTask = {}

local function TaskBar(pLength, pName, pRunCheck, pHidden)
    local p = promise:new()

    Citizen.CreateThread(function ()
        if pName then
            exports['np-taskbar']:taskBar(pLength, pName, pRunCheck, true, nil, false, function (result)
                p:resolve(result)
            end)
        else
            Citizen.SetTimeout(pLength, function() p:resolve(100) end)
        end
    end)

    return p
end

local function LoadAnimDict(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)

        local timeout = false
        Citizen.SetTimeout(60000, function () timeout = false end)

        while not HasAnimDictLoaded(animDict) and not timeout do
            Citizen.Wait(0)
        end
    end
end

function AnimationTask:new(pPed, pType, pText, pDuration, pDict, pAnim, pFlag)
    local this = {}

    this.ped = pPed;
    this.type = pType;
    this.flag = pFlag or 1;
    this.text = pText;
    this.active = false;
    this.duration = pDuration;
    this.dictionary = pDict;
    this.animation = pAnim;

    self.__index = self

    return setmetatable(this, self)
end

function AnimationTask:start(pTask)
    if self.active then return end

    if (pTask) then pTask(self) end

    self.active = true

    Citizen.CreateThread(function ()
        while self.active do
            if self.animation and not IsEntityPlayingAnim(self.ped, self.dictionary, self.animation, 3) then
                LoadAnimDict(self.dictionary)
                TaskPlayAnim(self.ped, self.dictionary, self.animation, -8.0, -8.0, -1, self.flag, 0, false, false, false);
            elseif not self.animation and not IsPedUsingScenario(self.ped, self.dictionary) then
                TaskStartScenarioInPlace(self.ped, self.dictionary, 0, true);
            end
            
            Citizen.Wait(100)
        end
    end)

    local task = TaskBar(self.duration, self.text)

    task:next(function ()
        self:stop()
    end)

    return task
end

function AnimationTask:stop()
    self.active = false
    StopAnimTask(self.ped, self.dictionary, self.animation, 3.0);
end

function AnimationTask:abort()
    if not (self.active) then return end
    exports['np-taskbar']:taskCancel();
end
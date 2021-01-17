
---- Pointing emote ---- Segment start ----

-- Key to use for pointing
-- "B", also called SpecialAbilitySecondary
-- Currently the check for this code occurs in a separate loop within the class,
-- should ideally be moved to the general keypress check loop
local pointingKeyCode = 29

-- Helper functions to speed things up
function _in(args) return Citizen.InvokeNative(table.unpack(args)) end
function map(f, r) local a = {} for i in pairs(r) do a[i] = f(r[i]) end return a end
function len(T) local n = 0 for _ in pairs(T) do n = n + 1 end return n end
function table.slice(tbl, first, last, step) local sliced = {} for i = first or 1, last or #tbl, step or 1 do sliced[#sliced+1] = tbl[i] end return sliced end
--

-- PointingTask class
local PointingTask = {
	_NativesLoop = {},
	_NativesPoint = {},
	_NativesLoadAnim = {},
	_variableReplacements = {},
	_pointingAllowed = true,
	_isPointing = false
}

PointingTask.__index = PointingTask

-- Functions to calculate pitch and heading angle for pointing
function PointingTask:_getPitch()
	local theta = GetGameplayCamRelativePitch()
	if (theta < -70) then theta = -70 end
	if (theta > 42) then theta = 42 end
	return (theta + 70)/112
end

function PointingTask:_getHeading()
	local theta = GetGameplayCamRelativeHeading()
	if (theta < -180) then theta = -180 end
	if (theta > 180) then theta = 180 end
	return -(theta + 180)/360+1
end

-- Replace variables that contain these strings with dynamic values calculated with the given function
PointingTask._variableReplacements = {
										['__Pitch'] = PointingTask._getPitch,
									  	['__Heading'] = PointingTask._getHeading,
									  	['__GetPlayerPed'] = function() return PlayerPedId() end
									 }

-- Processes the list of natives from the server
function PointingTask:_registerPointingNatives(args)
	self._NativesLoop = table.slice(args, 1, #args-3)
	self._NativesPoint = args[#args-2]
	self._NativesLoadAnim = table.slice(args, #args-1, #args)
end

-- Receives the list of natives from the server and passes it to the above function
function PointingTask:_nativesListener()
	RegisterNetEvent('receivePointingNatives')
	AddEventHandler('receivePointingNatives', function(args)
		self:_registerPointingNatives(args)
	end)
end

-- Replaces variable contents based on the variable replacements variable above
function PointingTask:_updateClientVariables(nativeArguments)
	t = {}
	for i = 1, len(nativeArguments) do
		t[i] = nativeArguments[i]
		for k in pairs(self._variableReplacements) do
			if nativeArguments[i] == k then t[i] = self._variableReplacements[k]() end
		end
	end
	return t
end

-- A loop that runs continuously and sets pitch, ...
function PointingTask:_pointingLoop()
	Citizen.CreateThread(function()
		while self._isPointing do
			if len(self._NativesLoop) == 0 then goto continue end
			map(function(t) return _in(self:_updateClientVariables(t)) end, self._NativesLoop)
			::continue::
			Citizen.Wait(0)
		end
	end)
end

-- Loads the base animation required
function PointingTask:_loadAnim()
	_in(self._NativesLoadAnim[1]) -- load anim
    while not _in(self._NativesLoadAnim[2]) do Citizen.Wait(0) end -- while not loaded
end

-- Checks for the conditions that need to be fulfilled for pointing to be allowed
function PointingTask:isPointingAllowed()
	if not self._pointingAllowed then return false end
	local dead = exports["isPed"]:isPed("dead")
	if dead then return false end
	if IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) then return false end -- handcuffed
	if O_2B5C4B1FBE761C ~= nil and O_2B5C4B1FBE761C == true then return false end -- also handcuffed
	if O_1641E96CBB5E61 ~= nil and O_1641E96CBB5E61 == true then return false end -- also dead
	if O_F6675863A508D5 ~= nil and O_F6675863A508D5 == true then return false end -- playing scenario ("emote") such as smoking
    return true
end

-- If we ever need to disable pointing externally
function PointingTask:disable()
	self._pointingAllowed = false
	self:stop()
end

-- To re-enable pointing
function PointingTask:enable()
	self._pointingAllowed = true
end

-- Constructor/New function
function PointingTask:new(...)
	self = setmetatable({}, PointingTask)
	Citizen.Trace('new')
	self:_nativesListener()
	TriggerServerEvent('fetchPointingNatives')
	return self
end

-- Start pointing
function PointingTask:start()
	Citizen.CreateThread(function()
		if not self:isPointingAllowed() then return end
		if len(self._NativesPoint) == 0 then return end
		self._isPointing = true
		self:_loadAnim()
		self:_pointingLoop()
	   	_in(self:_updateClientVariables(self._NativesPoint))
    end)
end

-- Stop pointing
function PointingTask:stop()
	Citizen.CreateThread(function()
		if not self:isPointingAllowed() then return end
		self._isPointing = false
		ClearPedSecondaryTask(PlayerPedId())
    end)
end

function PointingTask:toggle()
	Citizen.CreateThread(function()
		if self._isPointing == false then
				self:start()
		else
				self:stop()
		end
		self._isPointing = not self._isPointing 
    end)
end

-- Create instance
local taskCreated = false

AddEventHandler("np-base:playerSessionStarted", function()
	if taskCreated then return end
	playerPointing = PointingTask:new()

	-- Keybind loop
	Citizen.CreateThread(function()
		while true do
			if IsControlPressed(0, pointingKeyCode) and PointingTask:isPointingAllowed() then
				if not playerPointing._isPointing then playerPointing:start() end
			else
				if playerPointing._isPointing then playerPointing:stop() end
			end
			Citizen.Wait(0)
		end
	end)
	---- Pointing emote ---- Segment end ----
end)
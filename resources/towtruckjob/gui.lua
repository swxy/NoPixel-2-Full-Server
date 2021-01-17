-- Credit : Ideo
-- Credit : Ideo

Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}



Menu = {}
Menu.GUI = {}
Menu.buttonCount = 0
Menu.selection = 0
Menu.hidden = true
MenuTitle = "Menu"


function Menu.addButton(name, func,args,type,result,offset,degname,gName)
	local yoffset = 0.3
	local xoffset = 0
	local xmin = 0.2
	local xmax = 0.2
	local ymin = 0.04
	local ymax = 0.03
	Menu.GUI[Menu.buttonCount +1] = {}
	Menu.GUI[Menu.buttonCount +1]["offset"] = offset
	Menu.GUI[Menu.buttonCount+1]["garageName"] = gName
	Menu.GUI[Menu.buttonCount +1]["name"] = name
	Menu.GUI[Menu.buttonCount+1]["degname"] = degname
	Menu.GUI[Menu.buttonCount+1]["func"] = func
	Menu.GUI[Menu.buttonCount+1]["args"] = args
	Menu.GUI[Menu.buttonCount+1]["type"] = type
	Menu.GUI[Menu.buttonCount+1]["result"] = result
	Menu.GUI[Menu.buttonCount+1]["active"] = false
	Menu.GUI[Menu.buttonCount+1]["xmin"] = xmin + xoffset
	Menu.GUI[Menu.buttonCount+1]["ymin"] = ymin * (Menu.buttonCount + 0.01) +yoffset
	Menu.GUI[Menu.buttonCount+1]["xmax"] = xmax
	Menu.GUI[Menu.buttonCount+1]["ymax"] = ymax
	Menu.buttonCount = Menu.buttonCount+1
end


function Menu.updateSelection()
	if IsControlJustPressed(1, Keys["DOWN"])  then
		if(Menu.selection < Menu.buttonCount -1  )then
			Menu.selection = Menu.selection +1
		else
			Menu.selection = 0
		end
	elseif IsControlJustPressed(1, Keys["TOP"]) then
		if(Menu.selection > 0)then
			Menu.selection = Menu.selection -1
		else
			Menu.selection = Menu.buttonCount-1
		end
	elseif IsControlJustPressed(1, Keys["ESC"]) or IsControlJustPressed(1, Keys["BACKSPACE"]) then
		Menu.hidden = true
	elseif IsControlJustPressed(1, Keys["NENTER"])  then
			if Menu.GUI[Menu.selection +1]["type"] == 2 then
				TriggerEvent('towgarage:callSE2',Menu.GUI[Menu.selection +1]["args"],Menu.GUI[Menu.selection +1]["result"],Menu.GUI[Menu.selection +1]["degname"],Menu.GUI[Menu.selection +1]["garageName"],Menu.GUI[Menu.selection +1]["func"])
			elseif Menu.GUI[Menu.selection +1]["type"] == 1 or Menu.GUI[Menu.selection +1]["type"] == 4 then
				if Menu.GUI[Menu.selection +1]["result"] ~= 100 then
					TriggerEvent('towgarage:InitAmount',Menu.GUI[Menu.selection +1]["args"],Menu.GUI[Menu.selection +1]["degname"],Menu.GUI[Menu.selection +1]["result"],Menu.GUI[Menu.selection +1]["garageName"])

				end 
			elseif Menu.GUI[Menu.selection +1]["type"] == 3 then
				TriggerEvent('towgarage:callCE',Menu.GUI[Menu.selection +1]["result"],Menu.GUI[Menu.selection +1]["degname"],Menu.GUI[Menu.selection +1]["garageName"],Menu.GUI[Menu.selection +1]["func"]) 
			
			elseif Menu.GUI[Menu.selection +1]["type"] == 5 or Menu.GUI[Menu.selection +1]["type"] == 6 then

			else
				MenuCallFunction(Menu.GUI[Menu.selection +1]["func"], Menu.GUI[Menu.selection +1]["args"])
			end		
	end
	local iterator = 0
	for id, settings in ipairs(Menu.GUI) do
		Menu.GUI[id]["active"] = false
		if(iterator == Menu.selection ) then
			Menu.GUI[iterator +1]["active"] = true
		end
		iterator = iterator +1
	end
end

function Menu.renderGUI()
	if not Menu.hidden then
		Menu.renderButtons()
		Menu.updateSelection()
	end
end

function Menu.renderBox(xMin,xMax,yMin,yMax,color1,color2,color3,color4)
	DrawRect(xMin, yMin,xMax, yMax, color1, color2, color3, color4);
end

function Menu.renderButtons()

	local yoffset = 0.3
	local xoffset = 0.2

	local ScrapWorth = 10
	local price = 15

	SetTextFont(0)
	SetTextScale(0.0,0.35)
	SetTextColour(135, 206, 250, 255)
	SetTextCentre(true)
	SetTextDropShadow(0, 0, 0, 0, 0)
	SetTextEdge(0, 0, 0, 0, 0)
	SetTextEntry("STRING")
	AddTextComponentString(string.upper(MenuTitle))
	DrawText((xoffset), (yoffset - 0.05 - 0.0125 ))
	Menu.renderBox(xoffset,0.2,(yoffset - 0.05),0.05,0,0,0,215)

	if Menu.GUI[Menu.selection +1]["type"] == 2 then
		local percent = 0.05
		SetTextFont(6)
		SetTextScale(0.0,0.35)
		SetTextColour(255, 255, 255, 255)
		SetTextCentre(true)
		SetTextDropShadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
		SetTextEntry("STRING")
		local amountHold = 0

		if Menu.GUI[Menu.selection +1]["degname"] == "engine" or Menu.GUI[Menu.selection +1]["degname"] == "engine" then
			amountHold = math.floor((Menu.GUI[Menu.selection +1]["func"]/10))
		else
			amountHold = Menu.GUI[Menu.selection +1]["func"]	
		end

		local addPercent = amountHold+(ScrapWorth*Menu.GUI[Menu.selection +1]["args"])

        if addPercent >= 100 then addPercent = 100 end

		
		AddTextComponentString(addPercent.."%")

		DrawText(Menu.GUI[Menu.selection +1]["xmin"], 0.525)


		percent = addPercent/100*0.16

		Menu.renderBox(Menu.GUI[Menu.selection +1]["xmin"] ,Menu.GUI[Menu.selection +1]["xmax"], 0.56,0.03 ,15,15,15,200)
		Menu.renderBox(Menu.GUI[Menu.selection +1]["xmin"],Menu.GUI[Menu.selection +1]["xmax"], 0.55,0.003 ,15,15,15,255)
		Menu.renderBox(Menu.GUI[Menu.selection +1]["xmin"] ,Menu.GUI[Menu.selection +1]["xmax"], 0.54,0.03,15,15,15,200)
		Menu.renderBox(Menu.GUI[Menu.selection +1]["xmin"] ,percent, 0.545,0.003 ,221,72,53,255)	
		
	end

	for id, settings in pairs(Menu.GUI) do
		local screen_w = 0
		local screen_h = 0
		local textColor = {}
		screen_w, screen_h =  GetScreenResolution(0, 0)

		boxColor = {15,15,15,200}

		if(settings["active"]) then
			boxColor = {255,255,255,200}
			textColor = {0,0,0,255}
			SetTextColour(textColor[1], textColor[2], textColor[3], 255)
		end

		SetTextFont(6)
		SetTextScale(0.0,0.36)
		SetTextCentre(true)
		SetTextDropShadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
		SetTextEntry("STRING")
		if settings["type"] == 5 then
			if settings["garageName"] == false then
				AddTextComponentString("Unknown Part")
			else
				AddTextComponentString(settings["name"])
			end
		else
			AddTextComponentString(settings["name"])
		end
		if settings["type"] == 1 or settings["type"] == 4 or settings["type"] == 5 or settings["type"] == 6 then
			if settings["type"] == 5 then
				if settings["garageName"] == false then
					DrawText(settings["xmin"]+ (-0.07), (settings["ymin"] - 0.0125 ))
				else
					DrawText(settings["xmin"]+ (-0.07 + settings["offset"]), (settings["ymin"] - 0.0125 ))
				end
			end
			DrawText(settings["xmin"]+ (-0.07 + settings["offset"]), (settings["ymin"] - 0.0125 ))
		elseif settings["type"] == 2 then
			DrawText(settings["xmin"]+ settings["offset"], (settings["ymin"] - 0.0125 ))
		elseif settings["type"] == 3 then
			DrawText(settings["xmin"]+ settings["offset"], (settings["ymin"] - 0.0125 ))
		else
			DrawText(settings["xmin"]+ (settings["offset"]), (settings["ymin"] - 0.0125 ))
		end	
		if settings["type"] == 0 then
		Menu.renderBox(settings["xmin"],settings["xmax"], settings["ymin"], settings["ymax"],boxColor[1],boxColor[2],boxColor[3],boxColor[4])
		end
		
		if settings["type"] == 1 or settings["type"] == 4 or settings["type"] == 5 or settings["type"] == 6 then
			local percent = 0.05
			SetTextFont(6)
			SetTextScale(0.0,0.30)
			SetTextColour(255,255,255,255)
			SetTextCentre(true)
			SetTextDropShadow(0, 0, 0, 0, 0)
			SetTextEdge(0, 0, 0, 0, 0)
			SetTextEntry("STRING")
			if settings["type"] == 4 or settings["type"] == 6 then
				AddTextComponentString(math.floor(settings["result"]/10).."%")
			else
				AddTextComponentString(settings["result"].."%")
			end

			DrawText(settings["xmin"]+0.06, (settings["ymin"] - 0.0125 ))
			Menu.renderBox(settings["xmin"] ,settings["xmax"], settings["ymin"], settings["ymax"],boxColor[1],boxColor[2],boxColor[3],boxColor[4])
			percent = settings["result"]/100*0.18
			if settings["type"] == 4 or settings["type"] == 6 then
				Menu.renderBox(settings["xmax"] ,percent/10, settings["ymin"]+0.015, settings["ymax"]-0.025,221,72,53,100)
			else
				Menu.renderBox(settings["xmax"] ,percent, settings["ymin"]+0.015, settings["ymax"]-0.025,221,72,53,100)
			end
		end

		if settings["type"] == 2 then
			Menu.renderBox(settings["xmin"] ,settings["xmax"]-0.002, settings["ymin"], settings["ymax"],boxColor[1],boxColor[2],boxColor[3],boxColor[4])
		end
		if settings["type"] == 3 then
			Menu.renderBox(settings["xmin"] ,settings["xmax"]+0.002, settings["ymin"], settings["ymax"],boxColor[1],boxColor[2],boxColor[3],boxColor[4])
		end

	 end
end

--------------------------------------------------------------------------------------------------------------------

function ClearMenu()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

function MenuCallFunction(fnc, arg)
	if fnc == nil or arg == nil then
		return
	end
	_G[fnc](arg)
end

--------------------------------------------------------------------------------------------------------------------

Menu = {}
Menu.GUI = {}
Menu.buttonCount = 0
Menu.selection = 0
Menu.hidden = true
MenuTitle = "Menu"

function Menu.addButton(name, func,args)

	local yoffset = 0.3
	local xoffset = 0
	local xmin = 0.0
	local xmax = 0.3
	local ymin = 0.05
	local ymax = 0.05
	Menu.GUI[Menu.buttonCount+1] = {}
	Menu.GUI[Menu.buttonCount+1]["name"] = name
	Menu.GUI[Menu.buttonCount+1]["func"] = func
	Menu.GUI[Menu.buttonCount+1]["args"] = args
	Menu.GUI[Menu.buttonCount+1]["active"] = false
	Menu.GUI[Menu.buttonCount+1]["xmin"] = xmin + xoffset
	Menu.GUI[Menu.buttonCount+1]["ymin"] = ymin * (Menu.buttonCount + 0.01) +yoffset
	Menu.GUI[Menu.buttonCount+1]["xmax"] = xmax 
	Menu.GUI[Menu.buttonCount+1]["ymax"] = ymax 
	Menu.buttonCount = Menu.buttonCount+1
end


function Menu.updateSelection() 
	if IsControlJustPressed(3, 173) then 
		if(Menu.selection < Menu.buttonCount -1 ) then
			Menu.selection = Menu.selection +1
		else
			Menu.selection = 0
		end		
	elseif IsControlJustPressed(3, 172) then
		if(Menu.selection > 0)then
			Menu.selection = Menu.selection -1
		else
			Menu.selection = Menu.buttonCount-1
		end	
	elseif IsControlJustPressed(3, 176)  then
		MenuCallFunction(Menu.GUI[Menu.selection +1]["func"], Menu.GUI[Menu.selection +1]["args"])
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
local xoffset = 0

		SetTextFont(1)
		SetTextProportional(0)
		SetTextScale(1.0, 1.0)
		SetTextColour(255, 255, 255, 255)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextCentre(2)
		SetTextEntry("STRING")
		AddTextComponentString(string.upper(MenuTitle))
		DrawText((xoffset + 0.07), (yoffset - 0.065 - 0.0125 ))
		Menu.renderBox(xoffset,0.3,(yoffset - 0.05),0.05,20,20,255,150)
		
		
	for id, settings in pairs(Menu.GUI) do
		local screen_w = 0
		local screen_h = 0
		screen_w, screen_h =  GetScreenResolution(0, 0)
		
		if(settings["active"]) then
			boxColor = {255,255,255,150}
			SetTextColour(0, 0, 0, 255)
		else			
			boxColor = {0,0,0,150}
			SetTextColour(255, 255, 255, 255)	
		end
		SetTextFont(0)
		SetTextScale(0.0,0.35)
		SetTextCentre(false)
--		SetTextDropShadow(0, 0, 0, 0, 0)
		SetTextEdge(0, 0, 0, 0, 0)
		SetTextEntry("STRING") 
		AddTextComponentString(settings["name"])
		DrawText(settings["xmin"]+ 0.01, (settings["ymin"] - 0.0125 )) 
		Menu.renderBox(settings["xmin"] ,settings["xmax"], settings["ymin"], settings["ymax"],boxColor[1],boxColor[2],boxColor[3],boxColor[4])
	 end
end

function ClearMenu()
	--Menu = {}
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

function MenuCallFunction(fnc, arg)
	_G[fnc](arg)
end
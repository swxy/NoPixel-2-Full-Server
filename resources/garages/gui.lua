-- Credit : Ideo

--------------------------------------------------------------------------------------------------------------------
-- fonctions graphiques
--------------------------------------------------------------------------------------------------------------------

Menu = {}
Menu.GUI = {}
Menu.buttonCount = 0
Menu.selection = 0
Menu.hidden = true
MenuTitle = "Menu"

function Menu.addButton(name, func,args,extra,damages,bodydamages)

	local yoffset = 0.25
	local xoffset = 0.3
	local xmin = 0.0
	local xmax = 0.15
	local ymin = 0.03
	local ymax = 0.03
	Menu.GUI[Menu.buttonCount+1] = {}
	if extra ~= nil then
		Menu.GUI[Menu.buttonCount+1]["extra"] = extra
	end
	if damages ~= nil then
		Menu.GUI[Menu.buttonCount+1]["damages"] = damages
		Menu.GUI[Menu.buttonCount+1]["bodydamages"] = bodydamages
	end


	Menu.GUI[Menu.buttonCount+1]["name"] = name
	Menu.GUI[Menu.buttonCount+1]["func"] = func
	Menu.GUI[Menu.buttonCount+1]["args"] = args
	Menu.GUI[Menu.buttonCount+1]["active"] = false
	Menu.GUI[Menu.buttonCount+1]["xmin"] = xmin
	Menu.GUI[Menu.buttonCount+1]["ymin"] = ymin * (Menu.buttonCount + 0.01) +yoffset
	Menu.GUI[Menu.buttonCount+1]["xmax"] = xmax 
	Menu.GUI[Menu.buttonCount+1]["ymax"] = ymax 
	Menu.buttonCount = Menu.buttonCount+1
end


function Menu.updateSelection() 
	if IsControlJustPressed(1,173) then 
		if(Menu.selection < Menu.buttonCount -1 ) then
			Menu.selection = Menu.selection +1
		else
			Menu.selection = 0
		end		
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	elseif IsControlJustPressed(1,27) then
		if(Menu.selection > 0)then
			Menu.selection = Menu.selection -1
		else
			Menu.selection = Menu.buttonCount-1
		end	
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	elseif IsControlJustPressed(1,Controlkey["generalUse"][1]) or IsControlJustPressed(1,Controlkey["generalUseSecondary"][1]) then
		MenuCallFunction(Menu.GUI[Menu.selection +1]["func"], Menu.GUI[Menu.selection +1]["args"])
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
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
	DrawRect(0.7, yMin,0.15, yMax-0.002, color1, color2, color3, color4);
end

function Menu.renderButtons()
	
		local yoffset = 0.5
		local xoffset = 0

		
		
	for id, settings in pairs(Menu.GUI) do
		local screen_w = 0
		local screen_h = 0
		screen_w, screen_h =  GetScreenResolution(0, 0)
		
		boxColor = {13,11,10,233}
		local movetext = 0.0
		if(settings["extra"] == "In") then
			boxColor = {44,88,44,230}
		elseif (settings["extra"] ~= "Out") then
			movetext = -0.025
		end



		if(settings["active"]) then
			boxColor = {45,45,45,230}
		end


		if settings["extra"] ~= nil then

			SetTextFont(4)

			SetTextScale(0.34, 0.34)
			SetTextColour(255, 255, 255, 255)
			SetTextEntry("STRING") 
			AddTextComponentString(settings["name"])
			DrawText(0.63, (settings["ymin"] - 0.012 )) 

			SetTextFont(4)
			SetTextScale(0.26, 0.26)
			SetTextColour(255, 255, 255, 255)
			SetTextEntry("STRING") 
			AddTextComponentString(settings["extra"])
			DrawText(0.730 + movetext, (settings["ymin"] - 0.011 )) 


			SetTextFont(4)
			SetTextScale(0.31, 0.31)
			SetTextColour(11, 11, 11, 255)
			SetTextEntry("STRING") 
			AddTextComponentString(settings["damages"])
			DrawText(0.78, (settings["ymin"] - 0.012 )) 

			SetTextFont(4)
			SetTextScale(0.31, 0.31)
			SetTextColour(11, 11, 11, 255)
			SetTextEntry("STRING") 
			AddTextComponentString(settings["bodydamages"])
			DrawText(0.845, (settings["ymin"] - 0.012 )) 

			

			DrawRect(0.832, settings["ymin"], 0.11, settings["ymax"]-0.002, 255,255,255,199)
			--Global.DrawRect(x, y, width, height, r, g, b, a)
		else
			SetTextFont(4)
			SetTextScale(0.34, 0.34)
			SetTextColour(255, 255, 255, 255)
			SetTextCentre(true)
			SetTextEntry("STRING") 
			AddTextComponentString(settings["name"])
			DrawText(0.7, (settings["ymin"] - 0.012 )) 

		end




		Menu.renderBox(settings["xmin"] ,settings["xmax"], settings["ymin"], settings["ymax"],boxColor[1],boxColor[2],boxColor[3],boxColor[4])


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
	_G[fnc](arg)
end
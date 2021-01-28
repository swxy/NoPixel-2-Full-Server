-- GetUserInput function inspired by vMenu (https://github.com/TomGrobbe/vMenu/blob/master/vMenu/CommonFunctions.cs)
function GetUserInput(windowTitle, defaultText, maxInputLength)
  -- Create the window title string.
  local resourceName = string.upper(GetCurrentResourceName())
  local textEntry = resourceName .. "_WINDOW_TITLE"
  if windowTitle == nil then
    windowTitle = "Enter:"
  end
  AddTextEntry(textEntry, windowTitle)

  -- Display the input box.
  DisplayOnscreenKeyboard(1, textEntry, "", defaultText or "", "", "", "", maxInputLength or 30)
  Wait(0)
  -- Wait for a result.
  while true do
    local keyboardStatus = UpdateOnscreenKeyboard();
    if keyboardStatus == 3 then -- not displaying input field anymore somehow
      return nil
    elseif keyboardStatus == 2 then -- cancelled
      return nil
    elseif keyboardStatus == 1 then -- finished editing
      return GetOnscreenKeyboardResult()
    else
      Wait(0)
    end
  end
end

function handleArrowInput(center, heading)
  delta = 0.05
  DisableControlAction(0, 36, true)
  if IsDisabledControlPressed(0, 36) then -- ctrl held down
    delta = 0.01
  end

  DisableControlAction(0, 27, true)
  if IsDisabledControlPressed(0, 27) then -- arrow up
    local newCenter =  PolyZone.rotate(center.xy, vector2(center.x, center.y + delta), heading)
    return vector3(newCenter.x, newCenter.y, center.z)
  end
  if IsControlPressed(0, 173) then -- arrow down
    local newCenter =  PolyZone.rotate(center.xy, vector2(center.x, center.y - delta), heading)
    return vector3(newCenter.x, newCenter.y, center.z)
  end
  if IsControlPressed(0, 174) then -- arrow left
    local newCenter =  PolyZone.rotate(center.xy, vector2(center.x - delta, center.y), heading)
    return vector3(newCenter.x, newCenter.y, center.z)
  end
  if IsControlPressed(0, 175) then -- arrow right
    local newCenter =  PolyZone.rotate(center.xy, vector2(center.x + delta, center.y), heading)
    return vector3(newCenter.x, newCenter.y, center.z)
  end

  return center
end
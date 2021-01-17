RegisterNetEvent("polyzone:printShape")
AddEventHandler("polyzone:printShape", function(shape)
  file = io.open('polyzone_created_shapes.txt', "a")

  io.output(file)

  local output = parseShape(shape)

  io.write(output)

  io.close(file)
end)

function parseShape(shape)
  local printout = "--\nName: " .. shape.options.name .. " | " .. os.date("%x %I:%M %p\n\n")
  printout = printout .. "PolyZone:Create({\n"
  for i=1, #shape.points do
    if i ~= #shape.points then
      printout = printout .. "  vector2(" .. tostring(shape.points[i].x) .. ", " .. tostring(shape.points[i].y) .."),\n"
    else
      printout = printout .. "  vector2(" .. tostring(shape.points[i].x) .. ", " .. tostring(shape.points[i].y) ..")\n"
    end
  end

  printout = printout .. "}, {\n  name=\"" .. shape.options.name .. "\",\n  --minZ = " .. shape.options.minZ .. ",\n  --maxZ = " .. shape.options.maxZ .. "\n})\n\n"

  return printout
end
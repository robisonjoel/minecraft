os.loadAPI("ocs/apis/sensor")

-- Globals
rX=1 --Position of the radar, X Coords.
rY=1 --Position of the radar, Y Coords.
sT=4 --Tier of sensor (1 through 4)


-- Function to Find Monitor
function findMonitor()
   local monSide = ""
   for k, side in ipairs(rs.getSides()) do
      if peripheral.getType(side) == "monitor" then
         monSide = side
         local methodsMon = peripheral.getMethods(side)
       end
   end
   return monSide
end

monitor = peripheral.wrap(findMonitor())
monitor.setTextScale(2)
rW, rH = monitor.getSize() -- Query the monitor for the correct sizing

function convCoords(x,z) 
   local x2=((rW/2)+rX)+((rW/(sT*16))*x)
   local y2=((rH/2)+rY)+((rH/(sT*16))*z)
   return x2,y2
end

function drawPeeps() 
   local proximity = sensor.wrap("bottom")
   while true do
      redraw()
      local targets = proximity.getTargets()
      for k, v in pairs(targets) do
         if k == "jrobison" or k == "mprobison" then
            monitor.setTextColor(colors.blue)
         else
            monitor.setTextColor(colors.red)
         end
         monitor.setCursorPos(1, 1)
         entityX, entityY = convCoords(v.Position.X,v.Position.Z)

         monitor.setCursorPos(entityX, entityY)
         monitor.write("+"..k)
         monitor.setTextColor(colors.white)
      end
      os.sleep(.5)
   end
end


-- Draw Reticle
function redraw()
        local monitor = peripheral.wrap(findMonitor())
        monitor.clear()
        monitor.setBackgroundColor(colors.green)
        local chv = rH*0.5
        local chh = rW*0.5
        monitor.setCursorPos(chh, chv+1)
        monitor.write("|")
        monitor.setCursorPos(chh-1, chv)
        monitor.write("-+-")
        monitor.setCursorPos(chh, chv-1)
        monitor.write("|")
        monitor.setCursorPos(1, 2)

        monitor.setBackgroundColor(colors.green)
        monitor.setTextColor(term.isColor() and colors.white or colors.black)
        monitor.write()
end

redraw()
print( "Scanning for Peeps and stuff...")
drawPeeps()

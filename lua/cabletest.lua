
-- Function to Find Monitor
function findMonitor()
   local monSide = ""
   for k, side in ipairs(rs.getSides()) do
      if peripheral.getType(side) == "monitor" then
         monSide = side
       end
   end
   return monSide
end

mon = peripheral.wrap( findMonitor() )
mon.setCursorPos(1,1)
mon.clear()
print("Side: ", findMonitor() )

local wireSide = "top"
rs.setOutput( wireSide, false )
wires = rs.getBundledInput( wireSide )
print("Wires: ", wires)

rs.setBundledOutput( wireSide, 0 )
print("Wires: ",wires)
print("All colors Reset")

mon.setTextColor(colors.white) 
mon.setTextColor(colors.white)
mon.write( "Testing Monitor" )
mon.clear()
while true do
  rs.setBundledOutput( wireSide, 0 )
  local e, p1 = os.pullEvent( "redstone" )
  local rsChanges = rs.getBundledInput( wireSide )
  mon.clear()
  
  local loopCounter = 1
  for col,v in pairs(colors) do
    local colKey = colors[col]
    if type(colKey) == "number" then 
      local testColor = colors.test( rsChanges, colors[col])
      if testColor == true then
        mon.setCursorPos( 1, loopCounter )
        mon.setTextColor( colors[col] )
        mon.write( col .. " Is LIVE" )
        mon.setTextColor( colors.white )
        loopCounter = loopCounter + 1
        print( col, " live:\t\t\t", testColor)
      end
    end
  end 
end

--print("Sending continuous Pulses")
--while true do
--  rs.setBundledOutput( side, colors.white)
--  os.sleep(.2)
--  rs.setOutput( side, false )
--  rs.setBundledOutput( side, colors.white)
--  os.sleep(.2)
--  rs.setBundledOutput( side, colors.magenta )
--  os.sleep(.2)
--  rs.setBundledOutput( side, colors.purple)
--  os.sleep(.2)
--  rs.setBundledOutput( side, colors.pink )
--  os.sleep(.2)
--  rs.setBundledOutput( side, colors.blue)
--  os.sleep(.2)
--  rs.setBundledOutput( side, colors.red)
--  os.sleep(.2)
--  rs.setOutput( side, false )
----  local e, p1 = os.pullEvent( "key" )
--  print("E: ", e, p1)
--  if e == "key" then
--    if p1 == 16 then
--      print("User Says its time to quit, so fuckem im quitting")
--      break
--    end
--  end
--end

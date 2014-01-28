
-- how close a player has to be to activate the door
local radius = 3

-- Users that are allowed to Pass
allowedUsers = { "jrobison", "mprobison" }

-- Users that are DENIED access, will sound ALARM
deniedUsers = { "creeper", "skeleton" }

-- Where is the Door located? Must be touching a side of the computer/turtle
door = "top"

-- Where is the Alarm located? Must be touching a side of the computer/turtle
-- if no alarm is present, just list an empty side
alarm = "right"


-- DONT CHANGE ANYTHING BELOW HERE UNLESS YOU KNOW
-- WHAT YOU ARE DOING!!!!!

-- Load the Sensor API
os.loadAPI("ocs/apis/sensor")

-- This is the function to call to determine if the 
-- "username" supplied to the function matches what
-- is in the "allowedUsers" table
function isAllowed( username )
  for k, v in pairs( allowedUsers ) do
    if v == username then
      return true
    else
      return false
    end
  end
end

-- This is the function to call to determine if the 
-- "username" supplied to the function matches what
-- is in the "deniedUsers" table
function isDenied( username )
  for k, v in pairs( deniedUsers ) do
    if v == username then
      return true
    else
      return false
    end
  end
end

-- Function to find the Sensor, if attached
function findSensor()
   local deviceSide = ""
   for k, side in ipairs(rs.getSides()) do
      if peripheral.getType(side) == "sensor" then
         deviceSide = side
         return deviceSide
       end
   end
   error( "No Sensor Peripheral was found!!, stopping" )
end

-- the location of the redstone lamp relative to the sensor
-- X: Side to Side - Left and Right of the Sensor
-- Y: Forward and Back - North and South directions
-- Z: Up and Down
local offset = {
  X = 0,
  Y = 0,
  Z = -1 
}

 -- find the distance from the player position to the offset
function distance(pos)
  local xd = pos.X - offset.X
  local yd = pos.Y - offset.Y
  local zd = pos.Z - offset.Z
  return math.sqrt(xd*xd + yd*yd + zd*zd)
end


-- Check to see if there really is a Sensor attached
sensorSide = findSensor()
if sensorSide == true then
  local device = sensor.wrap( sensorSide )
  
end

print( "A sensor was found on my: ", sensorSide )
  
-- MAIN loop, this program spends most of its time here
local proximity = sensor.wrap( sensorSide )
print( "Starting Scanner.." )
while true do
  local doorSignal = false
  local alarmSignal = false
  local targets = proximity.getTargets()
  for entity, v in pairs( targets ) do
--        print( "DEBUG: ", entity, " - ", isAllowed( entity ) )
        if distance( v.Position ) < radius and isAllowed( entity ) then
          doorSignal = true
          print( entity, " has been granted access" )
        elseif distance( v.Position ) < radius and isDenied( entity ) then
          alarmSignal = true
          print( entity, " has been DENIED access" )
        end
  end
  rs.setOutput( door, doorSignal)
  rs.setOutput( alarm, alarmSignal)
  os.sleep( 1 ) -- Check for new infor every 1 second
end


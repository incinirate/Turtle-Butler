os.loadApi("file")

function up()
  
  --move turtle up
  repeat turtle.attackUp() until turtle.up()

  --add 1 to y coord in the coordTable table
  local coordTable = textUtils.unserialize(file.read("coordTracker"))
  coordTable.turtle.yCoord = coordTable.turtle.yCoord + 1
  file.write("coordTracker",textUtils.serialize(coordTable))
end

function down()
  
  --move turtle down
  repeat turtle.attackDown() until turtle.down()

  --remove 1 to y coord in the coordTable table
  local coordTable = textUtils.unserialize(file.read("coordTracker"))
  coordTable.turtle.yCoord = coordTable.turtle.yCoord - 1
  file.write("coordTracker",textUtils.serialize(coordTable))
end

function forward()
  
  --move the turtle forward
  repeat turtle.attack() until turtle.forward()

 --if statement seeing what direction the turtle is facing and then adding 1 to what direction its facing
  local coordTable = textUtils.unserialize(file.read("coordTracker"))
  local dir = coordTable.turtle.dir

  if dir == 1 then
  	coordTable.turtle.xCoord = coordTable.turtle.xCoord + 1

  elseif dir == 2 then
  	coordTable.turtle.zCoord = coordTable.turtle.zCoord + 1

  elseif dir == 3 then
  	coordTable.turtle.xCoord = coordTable.turtle.xCoord - 1

  elseif dir == 4 then
  	coordTable.turtle.zCoord = coordTable.turtle.zCoord - 1
  end

  file.write("coordTracker",textUtils.serialize(coordTable))
end

function right()
  
  --turns the turtle right
  turtle.turnRight()

  --add 1 to direction in the coordTable table and check if >4 then remove 4
  local coordTable = textUtils.unserialize(file.read("coordTracker"))
  coordTable.turtle.dir = coordTable.turtle.dir + 1

  if coordTable.turtle.dir>4 then

  	coordTable.turtle.dir = coordTable.turtle.dir - 4
  end

  file.write("coordTracker",textUtils.serialize(coordTable))
end

function left()
  
  --turns the turtle left
  turtle.turnLeft()

  --remove 1 from direction in the coordTable table and check if <1 then add 4
  local coordTable = textUtils.unserialize(file.read("coordTracker"))
  coordTable.turtle.dir = coordTable.turtle.dir + 1

  if coordTable.turtle.dir<1 then

  	coordTable.turtle.dir = coordTable.turtle.dir + 4
  end

  file.write("coordTracker",textUtils.serialize(coordTable))
end
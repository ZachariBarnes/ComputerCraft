local module = {}
DIRS = table.pack('N', 'E', 'S', 'W')
dirMethods = {}

dirMethods[1] = function subZ(loc)
    loc[3] = loc[3]-1
    return loc;
end

dirMethods[2] = function addX(loc)
    loc[1] = loc[1]+1
    return loc;
end

dirMethods[3] = function addZ(loc)
    loc[3] = loc[3]+1
    return loc;
end

dirMethods[4] = function subX(loc)
    loc[1] = loc[1]-1
    return loc;
end

function addY(loc)
    loc[2] = loc[2]+1
    return loc;
end

function subY(loc)
    loc[2] = loc[2]-1
    return loc;
end



function module.findIndex( table, value )
    for i = 1, #table do
        if table[i] == value then 
            return i 
        end
    end
    print( value ..' not found' ) 
    if index == -1 then
    print('Unable to proceed! Throwing Exception!')
    error('ERROR. Invalid facing direction:', value)
    end
end

function module.findFacingIndex( table, value )
    index = module.findIndex(table, value)
    return index
end

function module.turnL(face)
    index = module.findFacingIndex(DIRS, face[1])
    turtle.turnLeft()
    index = index -1
    if index < 1 then
        index = 4
    end
    print('Setting Face to:', DIRS[index])
    face[1] = DIRS[index]
    return face
end
   
function module.turnR(face)
    index = module.findFacingIndex(DIRS, face[1])
    turtle.turnRight()
    index = index + 1
    if index > 4 then
        index = 1
    end
    print('Setting Face to:', DIRS[index])
    face[1] = DIRS[index]
    return face
end

function module.moveToLoc(target, currentPos, face)

end

function module.turnToFace(targetDir, face)
    currentIndex = module.findFacingIndex(DIRS, face[1])
    targetDirIndex = module.findFacingIndex(DIRS, targetDir)
    print('Face:', face[1])
    print('currindex: ', currentIndex, ' TarIndex:', targetDirIndex)
    leftDistance = currentIndex + targetDirIndex
    if leftDistance > 4 then leftDistance = leftDistance - 4 end
    rightDistance = -currentIndex + targetDirIndex
    print(currentIndex,' + ',targetDirIndex,' = ',rightDistance)
    if rightDistance < 0 then rightDistance = rightDistance + 4 end
    print('Num Turns needed Left:', leftDistance)
    print('Num Turns needed Right:', rightDistance)
    if ( leftDistance <= rightDistance) then
        while face[1] ~= targetDir do
            print('Turning Left')
            face = module.turnL(face)
        end
    else
        while face[1] ~= targetDir do
            print('Turning Right')
            face = module.turnR(face)
        end
    end
    return face
end

function module.getNextLoc(coordinates, dir)

    index = findIndex(DIRS, dir)
    newCords = dirMethods[index](coordinates)
    return newCords
end

function module.digForward(coordinates, face)
    newLoc = module.getNextLoc(coordinates, face[1])
    count = 0
    while turtle.detect() and count<10 do
        turtle.dig('right')
        count = count+1
    end
    if(turtle.detect() and count == 10) then
        print('Error, unbreakable block')
        error('Unbreakable Block detected')
    else
        turtle.suck()
        turtle.forward()
        return newLoc
    end
    --We Didn't move, return old coordinates
    return coordinates
end

function module.moveForward(coordinates, face)
    newLoc = module.getNextLoc(coordinates, face[1])
    count = 0
    if turtle.detect() == false then
        turtle.forward()
        return newLoc
    else 
        error('Unable to Move in the specified direction:', face[1])
    end
    --We Didn't move, return old coordinates
    return coordinates
end

function module.digToLoc(targetLoc, pos, face)

end

return module
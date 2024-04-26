local module = {}
DIRS = table.pack('N', 'E', 'S', 'W')

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

return module
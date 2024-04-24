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
    print('ERROR. Invalid facing direction:', face)
    print('Unable to proceed! Throwing Exception!')
    error('ERROR. Invalid facing direction:', face)
    end
end

function module.findFacingIndex( table, value )
    index = module.findIndex(table, value)
    if index == -1 then
        print('ERROR. Invalid facing direction:', face)
        print('Unable to proceed! Throwing Exception!')
        error('ERROR. Invalid facing direction:', face)
    end
    return index
end

function module.turnL(face)
    index = module.findFacingIndex(DIRS, face[1])
    turtle.turnLeft()
    index = index -1
    if index < 1 then
        index = 4
    end
    face[1] = DIRS[index]
    return face
end
   
function module.turnR(face)
    index = module.findFacingIndex(DIRS, face[1])
    turtle.turnLeft()
    index = index + 1
    if index > 4 then
        index = 1
    end
    face[1] = DIRS[index]
    return face
end


return module
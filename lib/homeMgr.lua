-- pull in Home functions
-- require(home)


print('Booting up!')

local function printHome(x, y, z)
    print('X: ', x, ' Y: ', y, ' Z: ',z)
end

local function setHome()   
    print('Home Coordinates Needed!')
   
    home = {}
   
    print('X: ')
    home[x] = read()
    print('Y: ')
    home[y] = read()
    print('Z: ')
    home[z] = read()
       
    saveFile = io.open('/home','w')
    saveFile.write(home[x])
    saveFile.write(home[y])
    saveFile.write(home[z])
       
    print('Home Coordinates Set!')
    print('Home Coordinates are')
    printHome(home[x],home[y],home[z])
    io.close(saveFile)
    return home
end


local function getHome()
    saveFile =io.open('/home','r')
    if saveFile ~= nil then
        x = saveFile.read()
        y = saveFile.read()
        z = saveFile.read()
        printHome(x,y,z)
        io.close(saveFile)
    else
        setHome()
    end
end
   
getHome()
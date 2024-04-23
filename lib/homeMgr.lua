-- pull in Home functions
-- require(home)


print('Booting up!')

local function printCords(x, y, z)
    print('X: ', x, ' Y: ', y, ' Z: ',z)
end

local function setHome()   
    print('Home Coordinates Needed!')
   
    home = {}
   
    print('X: ')
    home[1] = read()
    print('Y: ')
    home[2] = read()
    print('Z: ')
    home[3] = read()
       
    handler = io.open('/home','w')
    io.output(handler)
    handler.write(handler, home[1],'\n')
    handler.write(handler, home[2],'\n')
    handler.write(handler, home[3],'\n')
       
    print('Home Coordinates Set!')
    printCords(home[1],home[2],home[3])
    io.close(saveFile)
    return home
end


local function getHome()
    write('Checking for Save Home Coordinates...')
    handler =io.open('/home','r')
    if handler ~= nil then
        x = handler.read(handler)
        y = handler.read(handler)
        z = handler.read(handler)
        home = table.pack(x,y,z)
        print('Save Home Coordinates Found! Are they correct? (y/n)')
        printCords(x,y,z)
        ans = read()
        if ans == 'y' then
            return home
        else
            return setHome()
        end
    else
        io.close(saveFile)
        return setHome()
    end
end
   
getHome()
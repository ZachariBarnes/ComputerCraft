local mgr = {}

function mgr.printCords(x, y, z)
    print('X: ', x, ' Y: ', y, ' Z: ',z)
end

function mgr.setHome()   
    print('Home Coordinates Needed!')
   
    home = {}
   
    print('X: ')
    home[1] = tonumber(read())
    print('Y: ')
    home[2] = tonumber(read())
    print('Z: ')
    home[3] = tonumber(read())
       
    handler = io.open('/home','w')
    io.output(handler)
    handler.write(handler, home[1],'\n')
    handler.write(handler, home[2],'\n')
    handler.write(handler, home[3],'\n')
       
    print('Home Coordinates Set!')
    mgr.printCords(home[1],home[2],home[3])
    io.close(saveFile)
    settings.load('.settings')
    settings.set('home', home)
    settings.save('.settings')
    return true
end


function mgr.getHome()
    write('Checking for Save Home Coordinates...')
    handler =io.open('/home','r')
    if handler ~= nil then
        x = tonumber(handler.read(handler))
        y = tonumber(handler.read(handler))
        z = tonumber(handler.read(handler))
        home = table.pack(x,y,z)
        print('Save Home Coordinates Found! Are they correct? (y/n)')
        mgr.printCords(x,y,z)
        ans = read()
        if ans == 'y' then
            settings.load('.settings')
            settings.set('home', home)
            settings.save('.settings')
            return true
        else
            home = setHome()
            settings.load('.settings')
            settings.set('home', home)
            settings.save('.settings')
            return true
        end
    else
        io.close(saveFile)
        home = setHome()
        settings.load('.settings')
        settings.set('home', home)
        settings.save('.settings')
        return true
    end
end
   
return mgr
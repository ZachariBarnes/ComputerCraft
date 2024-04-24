--required Libraries
homeMgr = require('lib.homeMgr')
t = require('lib.locomotion')
--Global Variables
home = {} -- Home Location (Next to Dropoff/Fuel)
x = 0
y = 0
z = 0
DIR = table.pack('N', 'E', 'S', 'W')
face = 'S' --Current Facing Direction
fuelDir = 'E' --Direction of FuelSource from HOME location
dropoffDir = 'N' --Direction of Dropoff from HOME location
mineDir = 'S' --Direction from which to quarry
l = 16 -- length of the proposed quarry
w = 16 -- width of the proposed quarry


local function setCords()
    print('Am I currently at the Home Coordinates? (y/n)')
    ans = read()
    while ans ~= 'y' do 
        print('What are my current Coorinates?')
        write('X: ')
        x = tonumber(read())
        write('Y: ')
        y = tonumber(read())
        write('Z: ')
        z = tonumber(read())
        print('Are these Cords Correct? (y/n)')
        homeMgr.printCords(x,y,z)
        ans = read()
    end
    print('Current Coordinates Set!')
end

local function setBox(name, var)
    print('From Home Cords, is the ', name ,' box ', var, '?  (y/n)')
    ans = read()
    while ans ~= 'y' do 
        print('From Home Cords, Where is the ', name ,' box? (N/S/E/W)')
        temp = read()
        var = string.upper(temp)
        print()
        print('Please confirm. The', name ,' box is ', var, 'of Home Loc? (y/n)')
        ans = read()
    end
    print(name, ' Direction Set!')
end

local function setMineDir()
    print('Am I currently facing the direction to dig in?(y/n)')
    ans = read()
    if(ans == 'y') then
        mineDir = face
    end
    while ans ~= 'y' do 
        print('What is the correct direction to dig in from Home? (N/S/E/W)')
        temp = read()
        mineDir = string.upper(temp)
        print()
        print('Please confirm. I should dig to the ', mineDir ,'? (y/n)')
        ans = read()
    end
    print('Mine Direction Set!')
end

local function setDirs()
    print('Am I currently facing ', face ,'? (y/n)')
    ans = read()
    while ans ~= 'y' do 
        print('What is my current heading? (N/S/E/W)')
        temp = read()
        face = string.upper(temp)
        print()
        print('Please confirm. Am I currently facing ', face ,'? (y/n)')
        ans = read()
    end
    print('Facing Direction Set!')
    setBox('Dropoff', dropoffDir)
    setBox('Fuel', fuelDir)
    setMineDir()
end

local function promptLength()
    print('How big of a hole should I dig? (default: ',l,'x',w,')')
    print('please enter the length of the dig. (Default: ', l ,')')
    length = tonumber(read())
    return length
end

local function getLength()
    length = promptLength()
    if length ~= nil then   
        print('Is ', length, ' the correct length? (y/n)')
        ans = read()
        while ans ~= 'y' do
            length = promptLength()
            print('Is ', length, ' the correct length? (y/n)')
            ans = read()
        end
        l = length
    end
end

local function promptWidth()
    print('please enter the Width of the dig. (Default: ', w ,')')
    width = tonumber(read())
    return width
end

local function getWidth()
    width = promptWidth()
    if width ~= nil then   
        print('Is ', width, ' the correct width? (y/n)')
        ans = read()
        while ans ~= 'y' do
            width = promptLength()
            print('Is ', width, ' the correct width? (y/n)')
            ans = read()
        end
        w = width
    end
end

local function getDigDimensions()
    getLength()
    getWidth()
end

local function init()
    print('Booting up!');
    --loadSaved()
    homeMgr.getHome();
    settings.load('.settings')
    home = settings.get('home', table.pack(0,0,0))
    print('Home loaded!')
    homeMgr.printCords(home[1],home[2], home[3])
    setCords()
    setDirs()
    getDigDimensions()
end 

init()
--refuel()

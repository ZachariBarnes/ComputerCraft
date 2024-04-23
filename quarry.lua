--required Libraries
homeMgr = require('./lib/homeMgr')

--Global Variables
home = {} -- Home Location (Next to Dropoff/Fuel)
x = 0
y = 0
z = 0
DIR = table.pack('N', 'E', 'S', 'W')
face = 'S' --Current Facing Direction
fuelDir = 'E' --Direction of FuelSource from HOME location
dropoffDir = 'N' --Direction of Dropoff from HOME location

local function setCords()
    print('Am I currently at the Home Coordinates? (y/n)')
    ans = read()
    while ans ~= 'y' do 
        print('What are my current Coorinates?')
        print('X: ')
        x = read()
        print('Y: ')
        y = read()
        print('Z: ')
        z = read()
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
        print('Please confirm. The', name ,' box is , ' var, 'of Home Loc? (y/n)')
        ans = read()
    end
    print(name, ' Direction Set!')
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
end

local function init()
    print('Booting up!');
    home = homeMgr.getHome();
    setCords()
    setDirs()
end 

init()
--required Libraries
homeMgr = require('lib.homeMgr')
t = require('lib.locomotion')
--Global Variables
home = {} -- Home Location (Next to Dropoff/Fuel)
loc = table.pack(0, 0, 0) -- X/Y/Z locations
DIRS = table.pack('N', 'E', 'S', 'W')
face = table.pack('S') --Current Facing Direction
fuelDir = 'E' --Direction of FuelSource from HOME location
dropoffDir = 'N' --Direction of Dropoff from HOME location
mineDir = 'S' --Direction from which to quarry
l = 16 -- length of the proposed quarry
w = 16 -- width of the proposed quarry

local function saveState(inProgress)
    settings.load('.settings')

    settings.set('home', home)
    settings.set('loc', loc)
    settings.set('face', face)

    savedDirs = table.pack(dropoffDir, fuelDir, mineDir)
    settings.set('savedDirs', savedDirs)

    dims = table.pack(l,w)
    settings.set('dims', dims)

    settings.set('inProgress', inProgress)
    settings.save('.settings')
end

local function loadState()
    settings.load('.settings')

    home = settings.get('home', home)
    loc = settings.get('loc', loc)
    face = settings.get('face', face)

    savedDirs = settings.get('savedDirs', table.pack(dropoffDir, fuelDir, mineDir))
    dropoffDir = savedDirs[1]
    fuelDir = savedDirs[2]
    mineDir = savedDirs[3]

    dims = settings.get('dims', table.pack(l,w))
    l = dims[1]
    w = dims[2]
    print('Successfully Loaded Save State')
end

local function inProgress()
    settings.load('.settings')
    resuming = settings.get('inProgress', false)
    return resuming
end

local function setCords()
    print('Am I currently at the Home Coordinates? (y/n)')
    ans = read()
    while ans ~= 'y' do 
        print('What are my current Coorinates?')
        write('X: ')
        loc[1] = tonumber(read()) -- X Coord
        write('Y: ')
        loc[2] = tonumber(read()) -- Y Coord
        write('Z: ')
        loc[3] = tonumber(read()) -- Z Coord
        print('Are these Cords Correct? (y/n)')
        homeMgr.printCords(loc[1],loc[2],loc[3])
        ans = read()
    end
    loc = home
    homeMgr.printCords(loc[1],loc[2],loc[3])
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
        mineDir = face[1]
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
    print('Am I currently facing ', face[1] ,'? (y/n)')
    ans = read()
    while ans ~= 'y' do 
        print('What is my current heading? (N/S/E/W)')
        temp = read()
        face[1] = string.upper(temp)
        print()
        print('Please confirm. Am I currently facing ', face[1] ,'? (y/n)')
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
    homeMgr.getHome();
    settings.load('.settings')
    home = settings.get('home', table.pack(0,0,0))
    print('Home loaded!')
    homeMgr.printCords(home[1],home[2], home[3])
    setCords()
    setDirs()
    getDigDimensions()
    saveState(true)
end

local function startUpManual()
    print('Booting up!');
    if inProgress() then
        print('Save state found. Would you like to resume? (y/n)')
        ans = read()
        --print('You Answered:', ans)
        if ans == 'y' then
            print('Attempting to Load Save State')
            loadState()
            return
        else init()
            return
        end
    else
        init()
    end
end 

local function getDistanceFromFuelBox()
    local xDistance = home[1] - loc[1] -- X coordinate
    if xDistance < 0 then xDistance = xDistance * -1 end

    --Don't Need to handle negative Y Becuase we always dig down
    local yDistance = home[2] - loc[2] -- Y Coordinate (Altitude)

    local zDistance = home[3] - loc[3] -- Z coordinate
    if zDistance < 0 then zDistance = zDistance * -1 end

    distance = xDistance + zDistance + yDistance
    print('Distance to fuel Box calculated as:', distance)
    return distance
end


local function refuel(fuelLevel, fuelNeeded)
    turtle.select(1)
    fuelIsPresent = turtle.refuel(0) -- Make sure Slot 1 is Combustable (charcoal?)
    if fuelIsPresent then

        while fuelLevel <= fuelNeeded and fuelIsPresent do
            if( turtle.getItemCount() == 1) then
                -- TODO: Look for other fuel Sources
                -- TODO: Save before Shutdown
                print('Out of Fuel')
                error('Not Enough Fuel. Please Add more')
            end
            turtle.refuel()
            fuelLevel = turtle.getFuelLevel()
            fuelIsPresent = turtle.refuel(0)
        end
    end
end

local function isFuelNeeded()
    turtle.select(1)
    if turtle.getItemCount() < 10 then
        return true
    end
    return false
end

local function fetchFuel()
    -- TODO: Go Get more Fuel
    if getDistanceFromFuelBox() > 0 then
        -- Move to Home Location
        t.moveToLoc(home, loc, face)
    end

    if face[1] ~= fuelDir then
        -- Turn to Face FuelBox
        face = t.turnToFace(fuelDir, face)
    end
    -- Retrieve stack of fuel
    turtle.suck()
    saveState(true)
end

local function manageFuel()
    fuelLevel = turtle.getFuelLevel()
    fuelNeeded = getDistanceFromFuelBox() + 1
    refuelNeeded = fuelLevel <= fuelNeeded
    --print('Fuel Needed: ', fuelNeeded, '<=', fuelLevel, 'is ', refuelNeeded)
    if refuelNeeded then 
        refuel(fuelNeeded, fuelLevel)
    else
        print('FuelCheck Good!')
    end

  if isFuelNeeded() then -- Low Fuel
        print('Low Fuel Detected, attempting to fetch more...')
        fetchFuel()
    end
end

function startDig()
    if face[1] ~= mineDir then
        -- Turn to Face Mine Direction
        face = t.turnToFace(mineDir, face)
    end
end

startUpManual()
manageFuel()
startDig()

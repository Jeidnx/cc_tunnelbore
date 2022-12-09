-- config

-- Total length of the tunnel
local length = 2
-- Height of the tunnel
local height = 2
-- width of the tunnel
local width = 3
-- blocks between torches
local torchSpacing = 15

-- end config

local function detectFront()
    if not turtle.detect() then
        turtle.select(2)
        turtle.place()
    end
end

local function detectDown()
    if not turtle.detectDown() then
        turtle.select(2)
        turtle.placeDown()
    end
end

local function detectUp()
    if not turtle.detectUp() then
        turtle.select(2)
        turtle.placeUp()
    end
end

local function detectLeft()
    turtle.turnLeft()
    if not turtle.detect() then
        turtle.select(2)
        turtle.place()
    end
    turtle.turnRight()
end

local function detectRight()
    turtle.turnRight()
    if not turtle.detect() then
        turtle.select(2)
        turtle.place()
    end
    turtle.turnLeft()
end

local torchCounter = 0
local function digLayer()
    -- expects the turtle to be in the bottom left of the tunnel. digs a widthxheight layer and fills any holes.
    torchCounter = torchCounter + 1
    turtle.dig()
    turtle.forward()

    -- begin first layer
    detectLeft()
    turtle.turnRight()
    if torchCounter == (torchSpacing + 1) then
        torchCounter = 0
        turtle.turnRight()
        turtle.select(1)
        turtle.place()
        turtle.turnLeft()
    end
    detectDown()
    local widthCounter = width
    while (widthCounter > 1)
    do
        turtle.dig()
        turtle.forward()
        detectDown()
        widthCounter = widthCounter - 1
    end
    detectFront()
    turtle.digUp()
    turtle.up()
    detectFront()
    if height > 2 then
        for i = 3, height do
            turtle.turnLeft()
            turtle.turnLeft()
            for i = 2, width do
		turtle.dig()
		turtle.forward()
	    end
            detectFront()
            turtle.digUp()
            turtle.up()
            detectFront()
        end
    end

    -- begin top layer
    detectFront()
    detectUp()
    turtle.turnLeft()
    turtle.turnLeft()
    widthCounter = width
    while (widthCounter > 1)
    do
        turtle.dig()
        turtle.forward()
        detectUp()
        widthCounter = widthCounter - 1
    end
    detectFront()
    for i = 1, height do
        turtle.down()
    end
    -- here the turtle ends up either at the bottom right
    -- or bottom left corner of the tunnel, depending on the height.
    -- we check if the number is even or not, and depending on the
    -- result, we adjust the turtles position.
    if height % 2 == 1 then
        turtle.turnLeft()
        turtle.turnLeft()
        for i = 1,width do
            turtle.forward()
        end
    end    
    turtle.turnRight()
   
end
    
-- first of all, check fuel.
local offset = 0
if height % 2 == 1 then
    offset = width - 1
end    
local currentFuel = turtle.getFuelLevel()
local requiredFuel = (height * width + offset - 1 + height) * length
print("Required Fuel: " .. requiredFuel)
print("Current Fuel amount: " .. currentFuel)
if currentFuel < requiredFuel then
    print("Additional Fuel needed: " .. requiredFuel - currentFuel)
else
    print("Fuel overhead: " .. currentFuel - requiredFuel)
    while (length > 0)
    do
        digLayer()
        length = length - 1
    end 
end


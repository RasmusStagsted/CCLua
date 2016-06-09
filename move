if not (os.loadAPI("fuel")) then
	print("Can't load 'fuel' API!")
	return false
end

local direction = "unknown"

function forward(length, force)
	if (length == nill) then
		length = 1
	end
	if (force == nill) then
		force = false
	end
	for i = 1, length, 1 do
		while not (turtle.forward()) do
			if not (turtle.detect()) then
				if (turtle.getFuelLevel() == 0) then
					fuel.refuel()
				end
			elseif (force) then
				turtle.dig()
			end
		end
	end
	return true
end

function backward(length, force)

	function move(turned)
		if (turned) then
			return turtle.forward()
		else
			return turtle.back()
		end
	end

	if (length == nill) then
		length = 1
	end
	if (force == nill) then
		force = false
	end

	local turned = false

	for i = 1, length, 1 do
		while not (move(turned)) do
			if (turtle.getFuelLevel() == 0) then
				fuel.refuel()
			else
				if not (turned) then
					turtle.turnLeft()
					turtle.turnLeft()
					turned = true
				end
				if not (turtle.detect()) then

				elseif (force) then
					turtle.dig()
				end
			end
		end
	end
	if (turned) then
		turtle.turnRight()
		turtle.turnRight()
	end
	return true
end

function up(length, force)
	if (length == nill) then
		length = 1
	end
	if (force == nill) then
		force = false
	end
	for i = 1, length, 1 do
		while not (turtle.up()) do
			if not (turtle.detectUp()) then
				if (turtle.getFuelLevel() == 0) then
					fuel.refuel()
				end
			elseif (force) then
				turtle.digUp()
			end
		end
	end
	return true
end

function down(length, force)
	if (length == nill) then
		length = 1
	end
	if (force == nill) then
		force = false
	end
	for i = 1, length, 1 do
		while not (turtle.down()) do
			if not (turtle.detectDown()) then
				if (turtle.getFuelLevel() == 0) then
					fuel.refuel()
				end
			elseif (force) then
				turtle.digDown()
			end
		end
	end
	return true
end

function left()
	turtle.turnLeft()
	if (direction == "north") then direction = "west"
	elseif (direction == "east") then direction = "south"
	elseif (direction == "south") then direction = "east"
	elseif (direction == "west") then direction = "north" end
end

function right()
	turtle.turnRight()
	if (direction == "north") then direction = "east"
	elseif (direction == "east") then direction = "south"
	elseif (direction == "south") then direction = "west"
	elseif (direction == "west") then direction = "north" end
end

function getDirection()
	print("Get direction")
	if (direction == "unknown") then
		for i = 1, 4, 1 do
			local x1, y1, z1 = gps.locate()
			if (forward()) then
				local x2, y2, z2 = gps.locate()

				if not (x1 == x2) then
					if (x1 < x2) then direction = "east"
					else direction = "west" end
				elseif not (z1 == z2) then
					if (z1 < z2) then direction = "south"
					else direction = "north" end
				end
				backward()
				return direction
			else
				right()
			end
		end
	end
	return direction
end

function face(targetDirection)
	if ((direction == "east" and targetDirection == "north") or
		(direction == "north" and targetDirection == "west") or
		(direction == "west" and targetDirection == "south") or
		(direction == "south" and targetDirection == "east")) then
		left()
	else
		while not (direction == targetDirection) do
			right()
		end
	end
end

function to(x, y, z, force)
	local x1, y1, z1 = gps.locate()
	return rel(x - x1, y - y1, z - z1, force)
end

function rel(x, y, z, force)
	print("Move rel: " .. x .. ", " .. y .. ", " .. z)
	if (direction == "unknown") then
		getDirection()
	end

	if (x < 0) then
		face("west")
	elseif (x > 0) then
		face("east")
	end
	if not (forward(math.abs(x))) then
		return -1
	end
	if (z < 0) then
		face("north")
	elseif (z > 0) then
		face("south")
	end
	if not (forward(math.abs(z))) then
		return -2
	end
	if (y > 0) then
		if not (up(y)) then
			return -3
		end
	elseif (y < 0) then
		if not (down(-y)) then
			return -3
		end
	end
	return 0
end

multiplayer = {}
function multiplayer.load()
	multiplayer.x = 1
	multiplayer.y = 640
	multiplayer.speed = 1.8
	multiplayer.add = 1
	multiplayer.width = 31
	multiplayer.height = 63
	multiplayer.health = 3
	multiplayer.score = 0
	multiplayer.bullets = 40
	multiplayer.highscore = 0
	multiplayer2_x = 2000
	multiplayer2_y = 2000
	update_time = 0
	updaterate = 0.001
	connection = "Connecting to server..."
	name = math.random(1,100000)
	multiplayer.player = name
end

function multiplayer.move(dt)
	if love.keyboard.isDown('d') and multiplayer.x < screenWidth - multiplayer.width then
		multiplayer.x = multiplayer.x + multiplayer.speed
	end
	if love.keyboard.isDown('a') and multiplayer.x > 1 then
		multiplayer.x = multiplayer.x - multiplayer.speed
	end
	if love.keyboard.isDown('s') and multiplayer.y < screenHeight - multiplayer.height then
		multiplayer.y = multiplayer.y + multiplayer.speed
	end
	if love.keyboard.isDown('w') and multiplayer.y > 1 then
		multiplayer.y = multiplayer.y - multiplayer.speed
	end
	if love.keyboard.isDown('r') then
		table.remove(enemy)
		table.remove(bullet)
		table.remove(powerup)
		multiplayer.load()
		level = 1
	end
	if love.keyboard.isDown('p') then
		gamestate = "pausemultiplayer"
	end
end
function multiplayer.shoot(key)
	if key == 'up' then
		if multiplayer.bullets > 0 then
			multiplayer.bullets = multiplayer.bullets - 1
			local dg = string.format("%s %s %f %s %s %f %f", 'multiplayer', 'bullet', score, 'up', multiplayer.player, multiplayer.x + multiplayer.width / 2, multiplayer.y)
			local snd = udp:send(dg)
			love.audio.play(laser)
		end
	end
	if key == 'down' then
		if multiplayer.bullets > 0 then
			local dg = string.format("%s %s %f %s %s %f %f", 'multiplayer', 'bullet', score, 'down', multiplayer.player, multiplayer.x + multiplayer.width / 2, multiplayer.y)
			local snd = udp:send(dg)
			multiplayer.bullets = multiplayer.bullets - 1
			love.audio.play(laser)
		end
	end
	if key == 'left' then
		if multiplayer.bullets > 0 then
			local dg = string.format("%s %s %f %s %s %f %f", 'multiplayer', 'bullet', score, 'left', multiplayer.player, multiplayer.x, multiplayer.y + multiplayer.height / 2)
			local snd = udp:send(dg)
			multiplayer.bullets = multiplayer.bullets - 1
			love.audio.play(laser)
		end
	end
	if key =='right' then
		if multiplayer.bullets > 0 then
			local dg = string.format("%s %s %f %s %s %f %f", 'multiplayer', 'bullet', score, 'right', multiplayer.player, multiplayer.x, multiplayer.y + multiplayer.height / 2)
			local snd = udp:send(dg)
			multiplayer.bullets = multiplayer.bullets - 1
			love.audio.play(laser)
		end
	end
end

function multiplayer.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(background, 1, 1)
	love.graphics.setColor(0,0,0)
	love.graphics.setFont(small)
	love.graphics.print("Health " .. multiplayer.health,1,1)
	love.graphics.print(connection,1,30)
	love.graphics.print("Score " .. multiplayer.score,screenWidth - 100,1)
	love.graphics.print("level " .. level,screenWidth - 300,1)
	love.graphics.print("Highscore " .. multiplayer.highscore,screenWidth - 500,1)
	love.graphics.print("Ammo " .. multiplayer.bullets,screenWidth - 700,1)
	for k, v in pairs(world) do
		if v.entity == "bullet" then
	        love.graphics.setColor(0,0,255)
			love.graphics.rectangle('fill',v.x,v.y,bullet.width,bullet.height)
		end
		if v.entity == "player" then
			love.graphics.setColor(255,255,255)
			love.graphics.draw(playeri, v.x, v.y)
		end
    end
    love.graphics.setColor(255,255,255)
	love.graphics.draw(playeri, multiplayer.x, multiplayer.y)
end
function multiplayer.refresh(dt)
	update_time = update_time + dt
	multiplayer.update()
	if update_time > updaterate then
		local dg = string.format("%s %s %f %s %s %f %f", 'multiplayer', 'player', score, 'no_command', multiplayer.player, multiplayer.x, multiplayer.y)
		local snd = udp:send(dg)
		multiplayer.update()
		update_time = 0
	end
end
function multiplayer.update()
	data, msg = udp:receive()
	if data then
		ent, entity, parms = data:match("^(%S*) (%S*) (.*)")
		local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
		assert(x and y)
		x, y = tonumber(x), tonumber(y)
		world[ent] = {x=x, y=y,entity = entity}
		connection = "Connected"
	else
		connection = "Connecting to server..."
	end
end

function score_load()
	address, port = "home.whhoesj.nl", 8091
	udp = socket.udp()
	udp:settimeout(1)
	udp:setpeername(address, port)
end
function multiplayer_network()
	address, port = "home.whhoesj.nl", 8091
	xreceive = "noreceive"
	yreceive = "noreceive"
	udp = socket.udp()
	udp:settimeout(0.01)
	udp:setpeername(address, port)
end
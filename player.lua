

player = {}
player.highscore = 0

function player.load()
	player.highscore = 0
	player.x = 1
	player.y = 640
	player.speed = 1.8
	player.add = 1
	player.width = 31
	player.height = 63
	player.health = 3
	player.score = 1
	player.bullets = 50
	playertime = 0
	playertimelim = 5
end
function player.save()
	if player.score > player.highscore then
		player.highscore = player.score
		love.filesystem.remove(score)
		file:open("w")
		file:write(player.highscore)
		file:close()
		player.highscore = tonumber(player.highscore)
	end
end
function player.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(background, 1, 1)
	love.graphics.draw(playeri, player.x, player.y)
	love.graphics.setColor(0,0,0)
	love.graphics.setFont(small)
	love.graphics.print("Health " .. player.health,1,1)
	love.graphics.print("Score " .. player.score,screenWidth - 100,1)
	love.graphics.print("level " .. level .. "/9",screenWidth - 300,1)
	file:open("r")
	player.highscore = file:read()
	file:close()
	player.highscore = tonumber(player.highscore)
	love.graphics.print("Highscore " .. player.highscore,screenWidth - 500,1)
	love.graphics.print("Ammo " .. player.bullets,screenWidth - 700,1)
	love.graphics.print("Network highscore: " .. networkhighscore,screenWidth - 1100,1)
end

function player.move()
	if love.keyboard.isDown('d') and player.x < screenWidth - player.width then
		player.x = player.x + player.speed
	end
	if love.keyboard.isDown('a') and player.x > 1 then
		player.x = player.x - player.speed
	end
	if love.keyboard.isDown('s') and player.y < screenHeight - player.height then
		player.y = player.y + player.speed
	end
	if love.keyboard.isDown('w') and player.y > 1 then
		player.y = player.y - player.speed
	end
	if love.keyboard.isDown('r') then
		table.remove(enemy)
		table.remove(bullet)
		table.remove(powerup)
		player.load()
		level = 1
	end
	if love.keyboard.isDown('p') then
		gamestate = "pause"
		player.save()
	end

end
function player.update(dt)
	playertime = playertime + dt
	if playertime > playertimelim then
		player.save()
		local score = tonumber(player.score)
		local nhighscore = tonumber(networkhighscore)
		if score ~= nil and nhighscore ~= nil then
			if player.highscore > nhighscore then
				local dg = string.format("%s %s %f %s %s %f %f", 'score', 'no_entity', player.highscore, 'no_command', multiplayer.player, 0, 0)
				local snd = udp:send(dg)
				datascore, msg = udp:receive()
				if datascore then
					print("Received: " .. datascore)
					networkhighscore = datascore
				end
			end
		end
		playertime = 0
	end
end
function player.shoot(key)
	if key == 'up' then
		if player.bullets > 0 then
			player.bullets = player.bullets - 1
			bullet.spawn(player.x + player.width / 2 - bullet.width / 2,player.y - bullet.height,'up')
			love.audio.play(laser)
		end
	end
	if key == 'down' then
		if player.bullets > 0 then
			player.bullets = player.bullets - 1
			bullet.spawn(player.x + player.width / 2 - bullet.width / 2,player.y + player.height,'down')
			love.audio.play(laser)
		end
	end
	if key == 'left' then
		if player.bullets > 0 then
			player.bullets = player.bullets - 1
			bullet.spawn(player.x - bullet.width,player.y + player.height / 2 - bullet.height / 2,'left')
			love.audio.play(laser)
		end
	end
	if key =='right' then
		if player.bullets > 0 then
			player.bullets = player.bullets - 1
			bullet.spawn(player.x + player.width,player.y + player.height / 2 - bullet.height / 2,'right')
			love.audio.play(laser)
		end
	end
end
function player.hit()
	for i,v in ipairs(enemy) do
		if player.x + player.width > v.x and player.x < v.x + v.width and player.y + player.height > v.y and player.y < v.y + v.height then
				table.remove(enemy, i)
				player.health = player.health - 1
		end
	end
end
function player.dead()
	if player.health < 1 then
		player.save()
		table.remove(enemy)
		table.remove(enemy)
		level = 1
		powerup.timer = 1
		enemy.timer = 0
		enemy.timerLim = 6
		table.remove(bullet)
		table.remove(powerup)
		table.remove(enemy)
		player.load()
	end
end

function player.nethighscore()
	local score = tonumber(player.score)
	local nhighscore = tonumber(networkhighscore)
		if nhighscore == 0 then
			udp:settimeout(1)
			local dg = string.format("%s %s %f %s %s %f %f", 'score', 'no_entity', score, 'no_command', multiplayer.player, 0, 0)
			local snd = udp:send(dg)
			print(dg)
			datascore, msg = udp:receive()
			if datascore then
				print("Received: " .. datascore)
				networkhighscore = datascore
			else
				receive = false
				networkhighscore = "no connection"
			end
			local score = tonumber(player.score)
			local nhighscore = tonumber(networkhighscore)
			udp:settimeout(0)
		end
end
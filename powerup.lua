powerup = {}
powerup.timer = 0
powerup.timerLim = math.random(9,15)
powerup.random = math.random(1,5)
powerup.height = 80
powerup.width = 80
shieldtimer = 0
shieldtimerlim = 10
function powerup.generate(dt)
	powerup.timer = powerup.timer + dt
	if powerup.random == 1 or powerup.random == 2 or powerup.random == 3 then
		powerup.add = "ammo"
	end
	if powerup.random == 4 then
		powerup.add = "health"
	end
	if powerup.random == 5 then
		powerup.add = "shield"
	end
	if powerup.timer > powerup.timerLim then
		powerup.spawn(math.random(1,love.graphics.getWidth() - powerup.width),math.random(1,love.graphics.getHeight() - powerup.height),powerup.add)


		powerup.timer = 0
		powerup.timerLim = math.random(9,15)
		powerup.side = math.random(1,5)
		powerup.random = math.random(1,4)
	end
end
function powerup.shielddraw()
	love.graphics.setColor(1,1,255)
	love.graphics.circle("line", player.x + player.width / 2, player.y + player.height / 2, 50)
end
function powerup.shield(dt)
	if shieldon == true then
		shieldtimer = shieldtimer + dt
		if shieldtimer > shieldtimerlim then
			shieldon = false
			shieldtimer = 0
		end
		for i,v in ipairs(enemy) do
			if player.x + player.width > v.x and player.x < v.x + v.width and player.y + player.height > v.y and player.y < v.y + v.height then
					table.remove(enemy, i)
			end
		end
	end
end
function powerup.spawn(x,y,add)
	table.insert(powerup, {x = x,y = y,height = powerup.height,width = powerup.width,add = add})
end
function powerup.draw()
	for i,v in ipairs(powerup) do
		if v.add == "health" then
			love.graphics.setColor(255,255,255)
			love.graphics.draw(poweruphealth,v.x,v.y)
		end
		if v.add == "ammo" then
			love.graphics.setColor(255,255,255)
			love.graphics.draw(ammop,v.x,v.y)
		end
		if v.add == "shield" then
			love.graphics.setColor(255,255,255)
			love.graphics.draw(shield,v.x,v.y)
		end
	end
end
function powerup.player()
	for i,v in ipairs(powerup) do
		if player.x + player.width > v.x and player.x < v.x + v.width and player.y + player.height > v.y and player.y < v.y + v.height then
				if v.add == "health" then
					player.health = player.health + 1
				end
				if v.add == "ammo" then
					player.bullets = player.bullets + 35
				end
				if v.add == "shield" then
					shieldon = true
				end
				table.remove(powerup, i)
		end
	end
end
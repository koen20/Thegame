enemy = {}

enemy.timer = 0
enemy.timerLim = math.random(4,6)
enemy.side = math.random(1,4)

function enemy.generate(min,max,dt,speed)
	enemy.timer = enemy.timer + dt + dt
	if enemy.timer > enemy.timerLim then
		if enemy.side == 1 then --left
			enemy.spawn(-50,math.random(1,screenHeight),speed)
		end
		if enemy.side == 2 then --top
			enemy.spawn(math.random(1,screenWidth),-50,speed)
		end
		if enemy.side == 3 then -- right
			enemy.spawn(screenWidth,math.random(1,screenHeight),speed)
		end
		if enemy.side == 4 then
			enemy.spawn(math.random(1,screenWidth), screenHeight,speed)
		end
		enemy.side = math.random(1,4)
		enemy.timerLim = math.random(min,max)
		enemy.timer = 0
	end
end


enemy.width = 75
enemy.height = 75

function enemy.spawn(x,y,speed)
	color = math.random(1,3)
	table.insert(enemy, {x = x,y = y,width = enemy.width,height = enemy.height,speed = speed,color = color})
end
function enemy.draw()
	for i,v in ipairs(enemy) do
		if v.color == 1 or v.color == 2 then
			love.graphics.setColor(255,255,255)
			love.graphics.draw(enemyp2,v.x,v.y)
		elseif v.color == 3 then
			love.graphics.setColor(255,255,255)
			love.graphics.draw(enemyp,v.x,v.y)
		end
	end
end
function enemy.move(dt)
	for i,v in ipairs(enemy) do
		if player.x + player.width / 2 < v.x + v.width / 2 then
			v.x = v.x - v.speed * dt
		end
		if player.x + player.width / 2 > v.x + v.width / 2 then
			v.x = v.x + v.speed * dt
		end
		if player.y + player.height / 2 < v.y + v.height / 2 then
			v.y = v.y - v.speed * dt
		end
		if player.y + player.height / 2 > v.y + v.height / 2 then
			v.y = v.y + v.speed * dt
		end
	end
end
function enemy.dead()
	for i,v in ipairs(enemy) do
		for ia,va in ipairs(bullet) do
			if va.x + va.width > v.x and va.x < v.x + v.width and va.y + va.height > v.y and va.y < v.y + v.height then
				table.remove(enemy, i)
				table.remove(bullet, ia)
				player.score = player.score + 1
			end
		end
	end
end
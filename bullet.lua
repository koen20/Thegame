bullet = {}
bullet.width = 5
bullet.height = 5
bullet.speed = 500

function bullet.spawn(x,y,dir)
	table.insert(bullet, {x = x, y = y, dir = dir, width = bullet.width, height = bullet.height})	
end
function bullet.draw()
	for i,v in ipairs(bullet) do
		love.graphics.setColor(0,0,255)
		love.graphics.rectangle('fill',v.x,v.y,bullet.width,bullet.height)
	end
end
function bullet.move(dt)
	for i,v in ipairs(bullet) do
		if v.dir == 'up' then
			v.y = v.y - bullet.speed * dt
		end
		if v.dir == 'down' then
			v.y = v.y + bullet.speed * dt
		end
		if v.dir == 'right' then
			v.x = v.x + bullet.speed * dt
		end
		if v.dir == 'left' then
			v.x = v.x - bullet.speed * dt
		end
	end
end
function bullet.destroy()
	for i,v in ipairs(bullet) do
		if v.x > screenWidth then
			table.remove(bullet, i)
		end
		if v.y > screenHeight then
			table.remove(bullet, i)
		end
		if v.x < 1 then
			table.remove(bullet, i)
		end
		if v.y < 1 then
			table.remove(bullet, i)
		end
	end
end
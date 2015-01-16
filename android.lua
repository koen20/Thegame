android = {}

function android.move(dt)
	x = love.mouse.getX()
	y = love.mouse.getY()
	if love.mouse.isDown("l") or love.mouse.isDown("r") then
        if x > 50 and x < 200 and y > 450 and y < 570 and player.y > 1 then
			player.y = player.y - player.speed
		end
		if x > 130 and x < 250 and y > 530 and y < 650 and player.x < screenWidth - player.width then
			player.x = player.x + player.speed
		end
		if x > 60 and x < 180 and y > 590 and y < 690 and player.y < screenHeight - player.height then
			player.y = player.y + player.speed
		end
		if x > 1 and x < 100 and y > 530 and y < 650 and player.x > 1 then
			player.x = player.x - player.speed
		end
    end
    if gamestate == "multiplayer" then
    	multiplayer.refresh(dt)
    end
end
function android.draw()
	--buttons
	love.graphics.draw(pause, 1, 25)
	--move
	love.graphics.draw(forward, 80, 480)
	love.graphics.draw(right, 150, 550)
	love.graphics.draw(down, 80, 600)
	love.graphics.draw(left, 1 , 550)
	--shoot
	love.graphics.draw(forward, 1030, 480)
	love.graphics.draw(right, 1100, 550)
	love.graphics.draw(down, 1030, 600)
	love.graphics.draw(left, 950 , 550)
end
function android.shoot(x,y)
	if x > 1000 and x < 1150 and y > 450 and y < 570 then
		if player.bullets > 0 then
			player.bullets = player.bullets - 1
			bullet.spawn(player.x + player.width / 2 - bullet.width / 2,player.y - bullet.height,'up')
			love.audio.play(laser)
		end
	end
	if x > 1010 and x < 1150 and y > 600 and y < 700 then
		if player.bullets > 0 then
			player.bullets = player.bullets - 1
			bullet.spawn(player.x + player.width / 2 - bullet.width / 2,player.y + player.height,'down')
			love.audio.play(laser)
		end
	end
	if x > 900 and x < 1040 and y > 490 and y < 640 then
		if player.bullets > 0 then
			player.bullets = player.bullets - 1
			bullet.spawn(player.x - bullet.width,player.y + player.height / 2 - bullet.height / 2,'left')
			love.audio.play(laser)
		end
	end
	if x > 1090 and x < 1200 and y > 520 and y < 640 then
		if player.bullets > 0 then
			player.bullets = player.bullets - 1
			bullet.spawn(player.x + player.width,player.y + player.height / 2 - bullet.height / 2,'right')
			love.audio.play(laser)
		end
	end
	if x > 1 and x < 50 and y > 25 and y < 75 then
		gamestate = "pause"
	end
end
function android.leave(key)
	if key == "escape" then
		love.event.quit()
	end
end
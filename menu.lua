
button = {}
instructions = {}
instructions.x = 1
instructions.y = screenHeight - 600
instructions.width = 1200
instructions.height = 500

function button_spawn(x,y,text,action)
	table.insert(button, {x = x,y = y,text = text,action = action})
end
function button_draw()
	for i,v in ipairs(button) do
		if gamestate == "pause" or
		gamestate == "pausemultiplayer" then
			if v.action == "resume" or
			v.action == "menu" or
			v.action == "quitp" then
				love.graphics.setColor(255,255,255)
				love.graphics.setFont(small)
				love.graphics.print(v.text,v.x,v.y)
			end
		end
		if gamestate == "menu" then
				if v.action == "play" or
				v.action == "quit" or
				v.action == "instructions" or
				v.action == "multiplayer" then
					love.graphics.setColor(0,0,0)
					love.graphics.setFont(large)
					love.graphics.print(v.text,v.x,v.y)
				end
		end
		if gamestate == "lobby" then
			if v.action == "join" or
			v.action == "lobbyback" then
				love.graphics.setColor(0,0,0)
				love.graphics.setFont(large)
				love.graphics.print(v.text,v.x,v.y)
			end
		end
	end
end
function button_click(x,y)
	for i,v in ipairs(button) do
		if x > v.x and 
		x < v.x + large:getWidth(v.text) and
		y > v.y and
		y < v.y + large:getHeight(v.text) then
			if gamestate == "menu" then
				if v.action == "play" then
					gamestate = "playing"
				end
				if v.action == "multiplayer" then
					lobby_load()
					gamestate = "lobby"
				end
				if v.action == "quit" then
					love.event.quit()
				end
				if v.action == "instructions" then
					gamestate = "instructions"
				end
			end
			if gamestate == "pause" then
				if v.action == "resume" then
					gamestate = "playing"
				end
				if v.action == "menu" then
					table.remove(enemy)
					table.remove(bullet)
					table.remove(powerup)
					player.load()
					level = 1
					gamestate = "menu"
				end
				if v.action == "quitp" then
					love.event.quit()
				end
			end
			if gamestate == "pausemultiplayer" then
				if v.action == "resume" then
					message = "unpaused"
					entity = 'noentity'
					action = 'command'
					local dg = string.format("%s %s %f %f %s %s", entity, action, x, y, message, multiplayer.player)
					udp:send(dg)
					gamestate = "multiplayer"
				end
				if v.action == "menu" then
					gamestate = "menu"
					message = 'quit'
					entity = 'noentity'
					action = 'command'
					local dg = string.format("%s %s %f %f %s %s", entity, action, x, y, message, multiplayer.player)
					udp:send(dg)
				end
				if v.action == "quitp" then
					message = 'quit'
					entity = 'noentity'
					action = 'command'
					local dg = string.format("%s %s %f %f %s %s", entity, action, x, y, message, multiplayer.player)
					udp:send(dg)
					love.event.quit()
				end
			end
			if gamestate == "instructions" then
				if v.action == "back" then
					gamestate = "menu"
				end
			end
			if gamestate == "lobby" and players ~= "no connection" then
				if v.action == "lobbyback" then
					gamestate = "menu"
				end
				if v.action == "join" then
					if players ~= 2 then
						lobbyrefresh = true
					end
				end
			end
		end
	end
end
function menu_draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(background, 1, 1)
end
function instructions_draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(background, 1, 1)
	love.graphics.setColor(123,123,123)
	love.graphics.rectangle('fill',instructions.x,instructions.y,instructions.width,instructions.height)
	love.graphics.setFont(medium)
	love.graphics.setColor(255,255,255)
	love.graphics.print("Instructions",instructions.width / 2 - medium:getWidth("Instructions"),instructions.y)
	love.graphics.print("Your health, score, highscore, ammo and level are showed on the top of the screen.",instructions.x,instructions.y + 50)
	love.graphics.print("You can move with w,a,s,d.",instructions.x,instructions.y + 100)
	love.graphics.print("You can shoot with the arrow keys.",instructions.x,instructions.y + 150)
	love.graphics.print("player: ",instructions.x,instructions.y + 200)
	love.graphics.draw(playeri, 100, instructions.y + 200)
	love.graphics.print("enemys: ",instructions.x,instructions.y + 300)
	love.graphics.draw(enemyp, 150, instructions.y + 300)
	love.graphics.draw(enemyp2, 250, instructions.y + 300)
	love.graphics.print("powerups: ",instructions.x,instructions.y + 400)
	love.graphics.draw(poweruphealth, 150, instructions.y + 400)
	love.graphics.draw(ammop, 250, instructions.y + 400)
	love.graphics.draw(shield, 350, instructions.y + 400)
	love.graphics.print("Back",instructions.x + instructions.width - 100,instructions.y + instructions.height - 40)
end
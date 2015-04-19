screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()
print("screenwidth: " .. screenWidth)
print("screenHeight: " .. screenHeight)
local entity, action, x, y, msg
socket = require "socket"
require "multiplayer"
require "player"
require "bullet"
require "enemy"
require "levels"
require "powerup"
require "menu"
require "pause"
require "android"
require "lobby"
world = {}

function love.load()
	--check os
	os_string = love.system.getOS()
	print(os_string)
	if os_string == "Android" then
		version = "android"
	else
		version = "pc"
	end
	--network
	address, port = "love2d.koenhabets.tk", 8091
	udp = socket.udp()
	udp:settimeout(0)
	udp:setpeername(address, port)
	--sound
	pause.load()
	pausex = screenWidth - 800
	pausey = screenHeight - 500
	laser = love.audio.newSource("laser.wav")

	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()

	--fonts
	large = love.graphics.newFont(40)
	medium = love.graphics.newFont(28)
	small = love.graphics.newFont(20)

	love.graphics.setBackgroundColor(255,255,255)

	--images
	--players
	playeri = love.graphics.newImage("player.png")
	--backgrounds
	background = love.graphics.newImage("background.png")
	--enemys
	enemyp = love.graphics.newImage("enemyp.png")
	enemyp2 = love.graphics.newImage("enemyp2.png")
	--powerups
	ammop = love.graphics.newImage("ammo.png")
	poweruphealth = love.graphics.newImage("poweruphealth.png")
	shield = love.graphics.newImage("shield.png")
	--android
	forward = love.graphics.newImage("forward.png")
	right = love.graphics.newImage("right.png")
	down = love.graphics.newImage("down.png")
	left = love.graphics.newImage("left.png")
	pause = love.graphics.newImage("pause.png")

	--load score from file
	file = love.filesystem.newFile("score")
	player.load()
	multiplayer.load()
	level = 1
	gamestate = "menu"
	networkhighscore = 0
	receive = true
	score = 0
	nhighscore = 1000
	if not love.filesystem.exists("score") then
		file:open("w")
		file:write(player.score)
		file:close()
	end

	--buttons
	--menu
	button_spawn(1,100,"Play","play")
	--if version == "pc" then
	button_spawn(1,200,"Multiplayer","multiplayer")
	--end
	button_spawn(1,screenHeight - 300,"Quit","quit")
	button_spawn(1,250,"Instructions","instructions")
	--pause screen
	button_spawn(pausex,pausey + 50,"Resume","resume")
	button_spawn(pausex,pausey + 100,"Menu","menu")
	button_spawn(pausex,pausey + 150,"Quit game","quitp")
	--lobby
	button_spawn(1,200,"Multiplayer join","join")
	button_spawn(multiplayer.x + multiplayer.width - 100,multiplayer.y + multiplayer.height - 40,"Back","lobbyback")
	--instructions
	button_spawn(instructions.x + instructions.width - 100,instructions.y + instructions.height - 40,"Back","back")


end
function love.quit()
	if gamestate == "multiplayer" then
		message = 'quit'
		entity = 'noentity'
		action = 'command'
		x = 0
		y = 0
		local dg = string.format("%s %s %f %f %s %s", entity, action, x, y, message, multiplayer.player)
		udp:send(dg)
		love.event.quit()
	else
		love.event.quit()
	end
end
function love.focus(f)
	if not f then
		if gamestate == "playing" then
			gamestate = "pause"
		end
		if gamestate == "mulitplayer" then
			gamestate = "pausemultiplayer"
		end
	end
end
function love.keypressed(key)
	if gamestate == "playing" then
		player.shoot(key)
	end
	if version == "android" then
		android.leave(key)
	end
	if gamestate == "multiplayer" then
		multiplayer.shoot(key)
	end
end

function love.update(dt)
	if gamestate == "playing" then
		enemy.dead()
		level_update(dt)
		bullet.move(dt)
		enemy.move(dt)
		enemy.dead()
		if shieldon ~= true then
			player.hit()
		end
		player.dead()
		player_levelup()
		powerup.generate(dt)
		powerup.player()
		player.move()
		bullet.destroy()
		player.nethighscore(dt)
		player.update(dt)
		powerup.shield(dt)
	end
	if gamestate == "multiplayer" then
		multiplayer.move(dt)
		multiplayer.refresh(dt)
		multiplayer.reset(dt)
		multiplayer.dead()
	end
	if gamestate == "menu" then
		player.nethighscore()
	end
	if version == "android" and gamestate == "playing" then
		android.move(dt)
	end
	if gamestate == "lobby" then
		lobby.update(dt)
		if lobbyrefresh == true then
			lobby.join(dt)
		end
	end
end

function love.draw()
	if gamestate == "menu" then
		menu_draw()
		button_draw()
	end
	if gamestate == "playing" then
		player.draw()
		bullet.draw()
		enemy.draw()
		powerup.draw()
		if shieldon == true then
			powerup.shielddraw()
		end
	end
	if gamestate == "pause" or gamestate == "pausemultiplayer" then
		pause_draw()
		button_draw()
	end
	if gamestate == "instructions" then
		instructions_draw()
	end
	if gamestate == "multiplayer" then
		multiplayer.draw()
	end
	if version == "android" and gamestate == "playing" then
		android.draw()
	end
	if gamestate == "lobby" then
		lobby.draw()
	end
end

function love.mousepressed(x,y)
	button_click(x,y)
	if gamestate == "playing" and version == "android" then
		android.shoot(x,y)
	end
end
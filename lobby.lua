lobby = {}
function lobby_load()
	address, port = "home.whhoesj.nl", 8091
	udp = socket.udp()
	udp:settimeout(0.01)
	udp:setpeername(address, port)
	lobbyx = 1
	lobbyy = screenHeight - 600
	lobbywidth = 1200
	lobbyheight = 500
	players = "no connection"
	lobbyupdatetime = 5
	lobbyupdatetimelim = 1
	lobbyrefreshtime = 0
	lobbyrefreshtimelim = 1
end
function lobby.draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(background, 1, 1)
	love.graphics.setColor(123,123,123)
	love.graphics.rectangle('fill',lobbyx,lobbyy,lobbywidth,lobbyheight)
	love.graphics.setColor(255,255,255)
	love.graphics.print("Mulitplayer",lobbyx,lobbyy)
	if lobbyrefresh == true then
		love.graphics.print("Waiting for players",1,200)
	else
		love.graphics.print("Join server:",1,200)
	end
	love.graphics.print("players: " .. players .. "/2",500,200)
end
function lobby.update(dt)
	lobbyupdatetime = lobbyupdatetime + dt
	if lobbyupdatetime > lobbyupdatetimelim then
		local dg = string.format("%s %s %f %s %s %f %f", 'lobbystatus', 'no_entity', score, 'no_command', multiplayer.player, 0, 0)
		udp:send(dg)
		data, msg = udp:receive()
		if data then
			players = data
			players = tonumber(players)
		else
			players = "no connection"
		end
		lobbyupdatetime = 0
	end
end
function lobby.join(dt)
	lobbyrefreshtime = lobbyrefreshtime + dt
	if lobbyrefreshtime > lobbyrefreshtimelim then
		local dg = string.format("%s %s %f %s %s %f %f", 'lobby', 'no_entity', score, 'no_command', multiplayer.player, 0, 0)
		udp:send(dg)
		data, msg = udp:receive()
		if data then
			players = data
		end
		lobbyrefreshtime = 0
	end
	if players == 2 or players > 2 then
		lobbyrefresh = false
		gamestate = "multiplayer"
	end
end
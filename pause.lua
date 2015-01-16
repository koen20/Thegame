pause = {}
function pause.load()
	pausex = screenWidth - 800
	pausey = screenHeight - 500
	pausewidth = 300
	pauseheight = 300
end

function pause_draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(background, 1, 1)
	love.graphics.setColor(123,123,123)
	love.graphics.rectangle('fill',pausex,pausey,pausewidth,pauseheight)
	love.graphics.setColor(255,255,255)
	love.graphics.print("pause",pausex + 100,pausey)
end
level1 = {}
level2 = {}
level3 = {}
level4 = {}
level5 = {}
level6 = {}
level7 = {}
level8 = {}
level9 = {}
level10 = {}
function player_levelup()
	if player.score == 5 then
		level = 2
	end
	if player.score == 20 then
		level = 3
	end
	if player.score == 30 then
		level = 4
	end
	if player.score == 50 then
		level = 5
	end
	if player.score == 100 then
		level = 6
	end
	if player.score == 200 then
		level = 7
	end
	if player.score == 350 then
		level = 8
	end
	if player.score == 480 then
		level = 9
	end
end
function level_update(dt)
	if level == 1 then
		level1.update(dt)
	end
	if level == 2 then
		level2.update(dt)
	end
	if level == 3 then
		level3.update(dt)
	end
	if level == 4 then
		level4.update(dt)
	end
	if level == 5 then
		level5.update(dt)
	end
	if level == 6 then
		level6.update(dt)
	end
	if level == 7 then
		level7.update(dt)
	end
	if level == 8 then
		level8.update(dt)
	end
	if level == 9 then
		level9.update(dt)
	end
end
function level1.update(dt)
	enemy.generate(4,6,dt,100)
end
function level2.update(dt)
	enemy.generate(3,6,dt,130)
end
function level3.update(dt)
	enemy.generate(2,5,dt,140)
end
function level4.update(dt)
	enemy.generate(2,3,dt,150)
end
function level5.update(dt)
	enemy.generate(1,2,dt,160)
end
function level6.update(dt)
	enemy.generate(0.5,2,dt,170)
end
function level7.update(dt)
	enemy.generate(0.5,1,dt,170)
end
function level8.update(dt)
	enemy.generate(0.4,0.9,dt,172)
end
function level9.update(dt)
	enemy.generate(0.3,0.8,dt,172)
end
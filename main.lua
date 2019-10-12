--[[
    Core File
--]]
micro = require "micro"
BACKGROUNDCOLOR = {25,25,25,255}


function love.load()
    love.graphics.setBackgroundColor(BACKGROUNDCOLOR)
    love.graphics.setDefaultImageFilter("nearest","nearest")
    love.keyboard.setKeyRepeat(.10, .10 )

	micro:load()

	--test micro ui
	local m = micro:new "test" --create the container, this is also the state for pseudo menus
	m.border = true
	local b = m:create "button"
	b.action = function() micro:deactive("test") m.visible = false end --deactive makes it not interactable, visible, well if yous can sees it, dummy.
 	local inp = m:create "input"
 	inp.x = 50
 	inp.y = 50
 	inp.maxchars = 50
end

function love.mousepressed()
	micro:mousePressed()
end

function love.mousereleased()
	micro:mouseReleased()
end

function love.wheelmoved()
	micro:wheelMoved(x,y)
end

function love.keypressed(key, isrepeat)
	micro:keyPressed(key)
end

function love.update(dt)
    --display:update(dt)
end

function love.draw()
    --camera:set()
    --display:draw()
    --camera:unset()
    micro:draw()
end

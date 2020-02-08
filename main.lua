--[[
    Core File
--]]
micro = require "micro"
BACKGROUNDCOLOR = {25,25,25,255}


function love.load()
    love.graphics.setBackgroundColor(BACKGROUNDCOLOR)
    love.graphics.setDefaultImageFilter("nearest","nearest")
    love.keyboard.setKeyRepeat(.10, .10 )

	--micro:load()

	--test micro ui
	ui = micro.new() --Initialize Micro
    --Start creating containers and things
	--Main Container
    menu = ui:new "main"
    
    --Add test button
    local button = menu:button {x = 500, y = 20, outline = true, alias = "regbutton"}
	button.action = function() menu:hide() menu:deactivate() ui.states["menu2"]:show() ui.states["menu2"]:activate() end --deactive makes it not interactable, visible, well if yous can sees it, dummy.
    
    --Add test input
 	local input = menu:input {x = 500, y = 80, maxchars = 20}
    
    --Textbloack
    local t = menu:text {output = "Howdy",x = 500, y = 150}
    
    local menu2 = ui:new "menu2"
    menu2:hide()
    menu2:deactivate()
    local button2 = menu2:button {x = 20, y = 20}

end

function love.mousepressed()
	ui:mousePressed()
end

function love.mousereleased()
	ui:mouseReleased()
end

function love.wheelmoved()
    ui:wheelMoved(x,y)
end

function love.keypressed(key, isrepeat)
	ui:keyPressed(key)
end

function love.update(dt)

end

function love.draw()
    --camera:set()
    --display:draw()
    --camera:unset()
    ui:draw()
end
